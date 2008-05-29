Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYE2NUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYE2NUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYE2NT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:19:57 -0400
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4788 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbYE2NT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:19:57 -0400
Subject: Re: Pipe buffers' limit of 16 * 4K
From: Miquel van Smoorenburg <miquels@cistron.nl>
To: Fausto Richetti Blanco <fausto.blanco@gmail.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, jengelh@medozas.de
In-Reply-To: <d8d698ae0805290600s782e16b4pe70d725f55826cf0@mail.gmail.com>
References: <d8d698ae0805231255i4d0da724p68cb2b9376134797@mail.gmail.com>
	 <d8d698ae0805231719g4202edf2k947bba4128385ab6@mail.gmail.com>
	 <20080523205630.444fe2b9@bree.surriel.com>
	 <d8d698ae0805261043u125b653ve73d067cd92caa16@mail.gmail.com>
	 <d8d698ae0805281422i21  <d8d698ae0805290600s782e16b4pe70d725f55826cf0@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 29 May 2008 15:19:24 +0200
Message-Id: <1212067164.8621.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 10:00 -0300, Fausto Richetti Blanco wrote:
> Yes, I need an unspecified amount (it is the data content of a HTTP POST).
> 
> The tee system call appeared in the 2.6.17 (I'm using 2.6.9). That's
> because I did my implementation using a buffer and copying it using
> write. Unfortunately, both solutions suffer from the kernel buffer
> limitation.
> 
> As I said, there's a lot of other solutions to my specific problem.
> I'll problably move my solution inside the lib =/ But I decided to
> write to this list to ask for dynamically adjustable sizes for the
> pipes' buffers. Is there any good reason for this not to be pushed to
> the kernel head ?

Why not use a socketpair() instead of a pipe(). You can adjust the size
with setsockopt SO_SNDBUF/SO_RCVBUF (see man socket(7))

Mike.

