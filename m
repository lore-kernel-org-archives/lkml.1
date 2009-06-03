Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbZFCQk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbZFCQk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 12:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbZFCQkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 12:40:17 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34613 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbZFCQkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 12:40:16 -0400
Date: Wed, 3 Jun 2009 09:40:13 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Gary Hade <garyhade@us.ibm.com>, mingo@elte.hu, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, x86@kernel.org,
       ebiederm@xmission.com, yinghai@kernel.org, lcm@us.ibm.com
Subject: Re: [RESEND] [PATCH v2] [BUGFIX] x86/x86_64: fix CPU offlining
	triggered "active" device IRQ interrruption
Message-ID: <20090603164013.GA7566@us.ibm.com>
References: <20090602193216.GC7282@us.ibm.com> <4A26014F.4070207@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A26014F.4070207@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 09:51:27PM -0700, H. Peter Anvin wrote:
> Gary Hade wrote:
> > Impact: Eliminates an issue that can leave the system in an
> >         unusable state.
> > 
> > This patch addresses an issue where device generated IRQs
> > are no longer seen by the kernel following IRQ affinity
> > migration while the device is generating IRQs at a high rate.
> > 
> 
> This patch doesn't seem to apply to current mainline.
> 
> What is your base?

git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
which Ingo encouraged me to use because it contained some of 
Yinghai Lu's recent changes that hadn't reached mainline yet.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc
