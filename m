Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbXGJQip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbXGJQip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbXGJQih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:38:37 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:3264 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbXGJQig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:38:36 -0400
Date: Tue, 10 Jul 2007 18:38:35 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Pawel Dziepak <hryssta@gmail.com>
cc: linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       hirofumi@mail.parknet.co.jp
Subject: Re: utimes() with vfat is problematic
In-Reply-To: <ec870ced0707100318g87f22f8wcaa6a715c064338@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707101836170.11053@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0707101142270.11053@fbirervta.pbzchgretzou.qr>
 <ec870ced0707100318g87f22f8wcaa6a715c064338@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 10 2007 12:18, Pawel Dziepak wrote:
>
> Single UNIX Specification says crealy that to do utimes on a file user
> have to had write permissions or be a file owner.

Linux does check for write permission, but _only_ for time=NULL.
Hence it would be helpful if someone knows the exact SUS text,
or whether this is not explicitly specified in SUS, leaving room
for interpretation.



	Jan
-- 
