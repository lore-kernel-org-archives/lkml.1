Return-Path: <linux-kernel-owner+w=401wt.eu-S1751936AbXAVTie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbXAVTie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 14:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932066AbXAVTid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 14:38:33 -0500
Received: from main.gmane.org ([80.91.229.2]:47742 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbXAVTid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 14:38:33 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Nicolas Bareil <nico@chdir.org>
Subject: Re: Linux 2.6.19.2 : Oops
Date: Mon, 22 Jan 2007 20:37:55 +0100
Message-ID: <87hcuiam3w.fsf@boz.loft.chdir.org>
References: <873b6a6ji0.fsf@boz.loft.chdir.org>
	<20070117233545.GA12717@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: moog.chdir.org
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.92 (gnu/linux)
Cancel-Lock: sha1:hIDES0FVYFt5ZSGIHxuhDiMA5g0=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:
>> Since 2.6.19, I get the following Oops once a day, always with the same
>> process, newspipe[1] which use a lot of CPU, threads and I/O.
>> 
>> The kernel is patched by Grsecurity. The ext3 filesystem is on a
>> software RAID device (the two disks are SATA2). I tested the 
>> hardware (RAM, SMART disks) but nothing seem problematic.
>
> Can you reproduce it without the grsec patch applied?

After 4 days of tests without grsec, I didn't had any Oops. So it seems
I will have to find this bug with the grsecurity developpers...

Thank you!
-- 
Nicolas Bareil                                  http://chdir.org/~nico/
OpenPGP=0xAE4F7057 Fingerprint=34DB22091049FB2F33E6B71580F314DAAE4F7057

