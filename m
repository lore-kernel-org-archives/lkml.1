Return-Path: <linux-kernel-owner+w=401wt.eu-S2993079AbXEBMfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993079AbXEBMfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993093AbXEBMfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:35:12 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:23782 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993079AbXEBMfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:35:10 -0400
Date: Wed, 2 May 2007 14:38:08 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, dmitry.torokhov@gmail.com, oneukum@suse.de,
       rpurdie@rpsys.net, stern@rowland.harvard.edu, maneesh@in.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] sysfs: sysfs rework, take #2
Message-ID: <20070502143808.37dd5ff0@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <11777675753460-git-send-email-htejun@gmail.com>
References: <11777675753460-git-send-email-htejun@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.11; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 22:39:35 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> All the known regrssions are fixed.  I think I've got all the
> attr->owner but haven't verified with cross compiling yet, just
> allyesconfig on x86-64 and i386.  I'll try to setup some cross compile
> environments tomorrow and follow up if I can find more fallouts.

s390 attr->owner seems to be fine afaics.

I've run some stress tests (attach/detach) on s390 and haven't run into
any problems yet.
