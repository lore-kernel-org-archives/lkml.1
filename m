Return-Path: <linux-kernel-owner+w=401wt.eu-S1763444AbZFQCXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763444AbZFQCXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 22:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbZFQCXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 22:23:19 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:28203 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbZFQCXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 22:23:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=F2qaQByCHDWUKE1bSAKcLHLZbaFdHVxJazfipGgpvza6LAhf7ZXrSHFeLeBZyAt3cE
         zVUQCyC7br3ZbEAax1X14KNp43UW3NrOMGlpvA5S+MR042J0iw6J1NVoNILc2cklfQJp
         BLIeYmFSvoywXful7Hh/+vv5tpjxCd+wFSjSk=
MIME-Version: 1.0
In-Reply-To: <4A34A3C0.80103@gmail.com>
References: <4A33A841.6080902@gmail.com>
	 <20090613140647.GD30053@uranus.ravnborg.org>
	 <4A34A3C0.80103@gmail.com>
Date: Tue, 16 Jun 2009 19:15:03 -0700
Message-ID: <6934efce0906161915t280bf69ek450b3c6220a7d379@mail.gmail.com>
Subject: Re: [PATCH 14/14] Pramfs: XIP operations
From: Jared Hulbert <jaredeh@gmail.com>
To: Marco <marco.stornelli@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I know. It wasn't my intention to introduce it but as I said in my first
> patch I've done a porting of this code from 2.6.10 and to remove it I
> need time to analyze well the code to avoid deadlock and so on. If
> someone would like to help me I'd really appreciate it. However I see
> the use of BKL even in other recent "mainlined" fs as ext4, so I
> preferred to move the porting effort on other areas. However it's the
> first item on my todo list.


Why do you need the lock in pram_find_and_alloc_blocks() to begin
with?  Why wouldn't a mutex work?
