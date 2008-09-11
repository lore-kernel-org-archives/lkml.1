Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbYIKUFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbYIKUFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 16:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbYIKUE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 16:04:59 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51154 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbYIKUE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:04:58 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serue@us.ibm.com, akpm@linux-foundation.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <E1KYNMl-0000TG-Qs@pomaz-ex.szeredi.hu>
	<20080827184600.GA8069@us.ibm.com>
	<E1KaxLm-0006OD-K8@pomaz-ex.szeredi.hu>
	<20080903220215.GA27705@us.ibm.com>
	<E1Kb0ml-0006qL-5M@pomaz-ex.szeredi.hu>
	<20080903224334.GA726@us.ibm.com>
	<E1Kb8Y0-0008Gh-FP@pomaz-ex.szeredi.hu>
	<20080904132804.GA14709@us.ibm.com>
	<E1KbFU3-0002Ne-Oe@pomaz-ex.szeredi.hu>
	<E1KbGwb-0002rl-49@pomaz-ex.szeredi.hu>
	<20080905153134.GA18367@us.ibm.com>
	<E1Kd3Mh-0001vk-F5@pomaz-ex.szeredi.hu>
	<m11vzrge86.fsf@frodo.ebiederm.org>
	<E1KdnOb-00068L-Eq@pomaz-ex.szeredi.hu>
	<m17i9icxme.fsf@frodo.ebiederm.org>
Date: Thu, 11 Sep 2008 12:58:22 -0700
In-Reply-To: <m17i9icxme.fsf@frodo.ebiederm.org> (Eric W. Biederman's message
	of "Thu, 11 Sep 2008 12:04:41 -0700")
Message-ID: <m1sks6bgkh.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0005]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: unprivileged mounts git tree
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> This also intersects in interesting ways with dcache pruning, and
> automounting.

In particular we already have mounts that expire.  So deleting the
files or directories of mount points (when allowed) should just be 
a case of expiring the mount point.

When it is ok to do that is a separate question.

Eric
