Return-Path: <linux-kernel-owner+w=401wt.eu-S934422AbZDAWAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934422AbZDAWAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 18:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934301AbZDAWAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 18:00:21 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:53706 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267AbZDAWAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 18:00:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=oU/dR2Ca01X4ples/iRf83/SlZgPdcJVGmENiAfSF4b1XqrXS23pCGZFnt80NcA/R3
         W5/fU/mkdUma8MoqkzPfMPoWiyF6Buw7gMMBTP3f9jwBVVAle/oqu4sHNzt57dQDq5P1
         9QbVd8sdUM5gqbWCvwIlR9H4uoJ+qxaciZpr0=
From: Harald Arnesen <skogtun.harald@gmail.com>
To: david@lang.hm
Cc: Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>
	<alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>
	<49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca>
	<49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de>
	<49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de>
	<49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed>
	<20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx>
	<gqr50k$4aq$1@ger.gmane.org>
	<alpine.DEB.1.10.0903311813390.28893@asgard.lang.hm>
	<49D3954A.9010309@tmr.com>
	<alpine.DEB.1.10.0904011311240.28893@asgard.lang.hm>
Date: Thu, 02 Apr 2009 00:00:04 +0200
In-Reply-To: <alpine.DEB.1.10.0904011311240.28893@asgard.lang.hm>
	(david@lang.hm's message of "Wed, 1 Apr 2009 13:15:34 -0700 (PDT)")
Message-ID: <87hc183uhn.fsf@basilikum.skogtun.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm writes:

>> Understood that it's not deliberate just careless. The two behaviors
>> which are reported are (a) updating a record in an existing file and
>> having the entire file content vanish, and (b) finding some one
>> else's old data in my file - a serious security issue. I haven't
>> seen any report of the case where a process unlinks or truncates a
>> file, the disk space gets reused, and then the systems fails before
>> the metadata is updated, leaving the data written by some other
>> process in the file where it can be read - another possible security
>> issue.
>
> ext3 eliminates this security issue by writing the data before the
> metadata. ext4 (and I thing XFS) eliminate this security issue by not
> allocating the blocks until it goes to write the data out. I don't
> know how other filesystems deal with this.

I've been wondering about that during the last days. How abut JFS and
data loss (files containing zeroes after a crash), as compared to ext3,
ext4, ordered and writeback journal modes? Is is safe?
-- 
Hilsen Harald.
