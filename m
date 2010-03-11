Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab0CKOdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:33:24 -0500
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:64505 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756027Ab0CKOdX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:33:23 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Mar 2010 09:33:22 EST
X-AuditID: 12074425-b7d00ae000002295-7c-4b98fe05e28a
Subject: Re: ATA 4 KiB sector issues.
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <201003111927.24829.knikanth@suse.de>
Date: Thu, 11 Mar 2010 09:28:11 -0500
Cc: Damian Lukowski <damian@tvk.rwth-aachen.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       James Bottomley <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Mark Lord <kernel@teksavvy.com>,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       aschnell@suse.de, jdelvare@suse.de
Content-Transfer-Encoding: 8BIT
Message-Id: <472A4C80-30CE-4875-8073-F7E61659B6F0@mit.edu>
References: <4B947393.2050002@kernel.org> <4B97C6A5.4010209@tvk.rwth-aachen.de> <17BB1CC0-9B13-401D-B6AA-90365208A042@mit.edu> <201003111927.24829.knikanth@suse.de>
To: Nikanth Karthikesan <knikanth@suse.de>
X-Mailer: Apple Mail (2.1077)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 11, 2010, at 8:57 AM, Nikanth Karthikesan wrote:
> 
> I guess, what he meant was, to keep filesystem blocks aligned, even if the 
> partition is not. Say if the partition is mis-aligned by 512-bytes, let the 
> filesystem waste 4k-512bytes and keep it's blocks aligned. But it might be a 
> case of over-engineering, possibly requiring disk format change.

Ah, yes, I agree with you; that's probably what he meant.

Sure, that's theoretically possible, but it would mean changing every single filesystem, and it would require a file system format change --- or at least a file system format extension.

It would seem to be way easier to simply fix the partitioning tools to do the right thing, though.

-- Ted

