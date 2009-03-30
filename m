Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbZC3Pzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbZC3Pzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 11:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbZC3Pza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 11:55:30 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:56568 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbZC3Pz1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 11:55:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=fmHsmmpdZ0jj46idutgGHcRDkRSTbqFitNAtXb8q+8AAW9K1YcO5o+4yG6EIZN/Ev5
         ukGTv7AdCO4CNIFZ36LFps1kI2mOiCSqSffMmNl7DimFGOeMW1KbaDafNr4xotD2qW4v
         +NdISZhd66H4LCLsPXdwKieW9xT3P2vV08AGY=
From: Diego Calleja <diegocg@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: replace() system call needed (was Re: EXT4-ish "fixes" in UBIFS)
Date: Mon, 30 Mar 2009 17:58:32 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-00124-g5bee17f; KDE/4.2.1; x86_64; ; )
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <49CCCB0A.6070701@nokia.com> <20090329122600.GA13737@elf.ucw.cz>
In-Reply-To: <20090329122600.GA13737@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903301758.32942.diegocg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Domingo 29 Marzo 2009 14:26:00 Pavel Machek escribió:

> ...but this should not be. If we want to make that explicit, we should
> provide "replace()" operation; where replace is rename that makes sure
> that source file is completely on media before commiting the rename.

An "ad Linus-em" counterexample:

"And if we have a Linux-specific magic system call or sync action, it's 
going to be even more rarely used than fsync(). Do you think anybody 
really uses the OS X FSYNC_FULL ioctl? Nope. Outside of a few databases, 
it is almost certainly not going to be used, and fsync() will not be 
reliable in general.

So rather than come up with new barriers that nobody will use, filesystem 
people should aim to make "badly written" code "just work" unless people 
are really really unlucky. Because like it or not, that's what 99% of all 
code is."
