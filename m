Return-Path: <linux-kernel-owner+w=401wt.eu-S1758477AbYFXQ0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477AbYFXQ0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 12:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbYFXQ0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 12:26:23 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:23253 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbYFXQ0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:26:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KlryUpKVNMpMYc5+JBtoa9C+s3CGpmIIwBnmFNPEIFjhhVHKnBKmUJEQVk3nOSkfKf
         ARtNVIIvIVgQVfkQA1jwa0dCxtMS6nPyBBf2PVGROrlyjCN0BrIAVrSyvBjx3x/9FN7u
         Y1mZDIz7FViajYFl/Z6P8Xvx130ddLHqr7F/c=
Date: Tue, 24 Jun 2008 20:25:54 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, macro@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/5] x86 nmi_watchdog rework
Message-ID: <20080624162554.GA19162@cvg>
References: <48611ec7.1636440a.75ee.2504@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48611ec7.1636440a.75ee.2504@mx.google.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Tue, Jun 24, 2008 at 08:16:24PM +0400]
| Here are a series of patches over nmi-watchdog code. The base idea
| is to simplify the code. Please review. Any feedback is quite welcome!
| 
| The patches are over tip/master
| 
| commit e3686a37bb64e5ba21d1b522e92d246ba3b28d17
| Merge: 9aabe3d... fe4ff08...
| Author: Ingo Molnar <mingo@elte.hu>
| Date:   Sat Jun 21 08:02:44 2008 +0200
| 
|     Merge branch 'out-of-tree'
| 
| 		- Cyrill -
| -- 
| 

Hmm, sendmail somehow screwed about current date - log:

cyrill@cvg linux-2.6.git $ quilt mail --send --sender "Cyrill Gorcunov
<gorcunov@gmail.com>" --from "Cyrill Gorcunov <gorcunov@gmail.com>" --cc
"Cyrill Gorcunov <gorcunov@gmail.com>",linux-kernel@vger.kernel.org --to
mingo@elte.hu,tglx@linutronix.de,hpa@zytor.com,macro@linux-mips.org
sendmail -f Cyrill Gorcunov <gorcunov@gmail.com> mingo@elte.hu tglx@linutronix.de
hpa@zytor.com macro@linux-mips.org gorcunov@gmail.com linux-kernel@vger.kernel.org
date: invalid date `Tue, 24 Jun 2008 20:16:24 +0400\nSat Jun 21 08:02:44 2008 +0200'
cyrill@cvg linux-2.6.git $ date
Tue Jun 24 20:21:50 MSD 2008

so my patches are sent with 1 jan 1970 ;)
Should I remail them?

		- Cyrill -
