Return-Path: <linux-kernel-owner+w=401wt.eu-S1422627AbXCON75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422627AbXCON75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 09:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422668AbXCON75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 09:59:57 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:54858 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422627AbXCON74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 09:59:56 -0400
X-AuditID: d80ac287-a1a6bbb000000de9-f9-45f9515b5ea6 
Date: Thu, 15 Mar 2007 13:59:53 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Oliver Neukum <oneukum@suse.de>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Maneesh Soni <maneesh@in.ibm.com>, gregkh@suse.de,
       Richard Purdie <rpurdie@rpsys.net>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
In-Reply-To: <d120d5000703150622o43763828h5e01f313a3194f39@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0703151356370.20812@blonde.wat.veritas.com>
References: <20070314194337.5d439dab@gondolin.boeblingen.de.ibm.com> 
 <20070315112725.7eadb7b7@gondolin.boeblingen.de.ibm.com> 
 <Pine.LNX.4.64.0703151219540.12584@blonde.wat.veritas.com> 
 <200703151402.08097.oneukum@suse.de> <d120d5000703150622o43763828h5e01f313a3194f39@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 15 Mar 2007 13:59:55.0432 (UTC) FILETIME=[35DC6A80:01C7670A]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007, Dmitry Torokhov wrote:
> 
> How about sysfs_schedule_work? That is what it does - schedules a work
> on a sysfs object and everyone here knows what schedule_work() does.

I'm ashamed to have suggested anything else: certainly gets my vote.

Hugh
