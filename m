Return-Path: <linux-kernel-owner+w=401wt.eu-S1756995AbYE2Ogo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbYE2Ogo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 10:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYE2Oge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 10:36:34 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50767 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbYE2Ogd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 10:36:33 -0400
Date: Thu, 29 May 2008 16:36:32 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Miquel van Smoorenburg <miquels@cistron.nl>
cc: Fausto Richetti Blanco <fausto.blanco@gmail.com>,
       linux-kernel@vger.kernel.org, riel@redhat.com
Subject: Re: Pipe buffers' limit of 16 * 4K
In-Reply-To: <1212067164.8621.3.camel@localhost.localdomain>
Message-ID: <alpine.LNX.1.10.0805291633000.19264@fbirervta.pbzchgretzou.qr>
References: <d8d698ae0805231255i4d0da724p68cb2b9376134797@mail.gmail.com>  <d8d698ae0805231719g4202edf2k947bba4128385ab6@mail.gmail.com>  <20080523205630.444fe2b9@bree.surriel.com>  <d8d698ae0805261043u125b653ve73d067cd92caa16@mail.gmail.com>  <d8d698ae0805281422i21
  <d8d698ae0805290600s782e16b4pe70d725f55826cf0@mail.gmail.com> <1212067164.8621.3.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-05-29 15:19, Miquel van Smoorenburg wrote:
>On Thu, 2008-05-29 at 10:00 -0300, Fausto Richetti Blanco wrote:
>
>Why not use a socketpair() instead of a pipe(). You can adjust the size
>with setsockopt SO_SNDBUF/SO_RCVBUF (see man socket(7))

Nah, if there's lots of POST requests, and a large buffer for
each of it, you may end up running into allocation failures.
