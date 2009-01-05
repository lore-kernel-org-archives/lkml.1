Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbZAEDWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbZAEDWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 22:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZAEDWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 22:22:08 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:17992 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbZAEDWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 22:22:07 -0500
To: Pavel Machek <pavel@suse.cz>
Cc: Rob Landley <rob@landley.net>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20090103123813.GA1512@ucw.cz>
	<200901041349.49906.rob@landley.net>
	<20090104225545.GF1913@elf.ucw.cz>
Date: Sun, 04 Jan 2009 22:20:52 -0500
In-Reply-To: <20090104225545.GF1913@elf.ucw.cz> (Pavel Machek's message of "Sun\, 4 Jan 2009 23\:55\:45 +0100")
Message-ID: <yq1r63i30bv.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.49617C98.0122:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Pavel" == Pavel Machek <pavel@suse.cz> writes:

Pavel> Does this sound like a fair summary?

Pavel> Sector writes are atomic (ATOMIC-SECTORS)
Pavel> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

I'd just like to point out that the all-or-nothing hardware sector
atomity thing is -- to a large extent -- a myth.

It is mostly true on SCSI class devices because various UNIX, RAID array
and database vendors have spent many years leaning very hard on the
drive manufacturers to make it so.

But it's not a hard guarantee, you can't get it in writing, and it's not
in any of the standards.  Hybrid drives with flash had potential to
close that particular loophole but those appear to be dead in the water.

-- 
Martin K. Petersen	Oracle Linux Engineering

