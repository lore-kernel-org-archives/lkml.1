Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbZCCXdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbZCCXdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 18:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbZCCXdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 18:33:44 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53008 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbZCCXdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 18:33:43 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49ADBE29.4040706@s5r6.in-berlin.de>
Date: Wed, 04 Mar 2009 00:32:57 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jan Engelhardt <jengelh@medozas.de>,
       Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Large amount of scsi-sgpool objects
References: <alpine.LSU.2.00.0903030220050.2438@fbirervta.pbzchgretzou.qr> <49ACF8FE.2020904@panasas.com> <1236093718.3263.3.camel@localhost.localdomain> <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr> <1236097526.3263.17.camel@localhost.localdomain> <20090303192212.GA20705@elte.hu> <1236115544.15993.22.camel@localhost.localdomain> <20090303214454.GA8288@elte.hu> <1236119990.24019.35.camel@localhost.localdomain> <20090303230323.GA21644@elte.hu>
In-Reply-To: <20090303230323.GA21644@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i picked up a v1 patch from the SCSI list that 
> i reported and which patch was sent to me. I did that in the 
> hope to fix a serious lockup bug that is still unfixed in the
> upstream kernel

Perhaps you could avoid putting such fixes into published merge
branches.  Have it in an off-topic branch and tell people with affected
systems to locally merge such a branch themselves if it is strictly
necessary to keep their development rolling.  (And if such an off-topic
branch turns out to be unexpectedly long-lived, ping the choke point.)
Just so that there is minimal surprise about which modifications your
trees carry.
-- 
Stefan Richter
-=====-==--= --== --=--
http://arcgraph.de/sr/
