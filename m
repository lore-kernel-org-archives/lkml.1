Return-Path: <linux-kernel-owner+w=401wt.eu-S1757282AbYC1STK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbYC1STK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbYC1SS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:18:57 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:64168 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbYC1SS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:18:56 -0400
Subject: Re: [PATCH 1/2 v4] Driver for Freescale 8610 and 5121 DIU
From: York Sun <yorksun@freescale.com>
To: avorontsov@ru.mvista.com
Cc: Scott Wood <scottwood@freescale.com>,
       linux-fbdev-devel@lists.sourceforge.net, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, Timur Tabi <timur@freescale.com>
In-Reply-To: <20080328174853.GA1438@localhost.localdomain>
References: <12066720572512-git-send-email-yorksun@freescale.com>
	 <12066720572314-git-send-email-yorksun@freescale.com>
	 <47ED2B35.4030601@freescale.com>
	 <20080328174853.GA1438@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 28 Mar 2008 13:18:49 -0500
Message-Id: <1206728329.10785.12.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Mar 2008 18:18:50.0922 (UTC) FILETIME=[2C4B50A0:01C89100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-28 at 20:48 +0300, Anton Vorontsov wrote:
> > >+		if (copy_from_user(&pix_fmt, (void __user *)arg,
> > >+				sizeof(pix_fmt)))
> > 
> > OK, you fixed the cast here...
> 
> Maybe better would be to define "buf" at the top of this function as
> void __user *buf = (void __user *)arg;, i.e. just once?

I think it is a good idea.

> 
> > 
> > >+			return -EFAULT;
> > >+		ad->pix_fmt = pix_fmt;
> > >+		pr_debug("Set pixel format to 0x%08x\n", ad->pix_fmt);
> > >+		break;
> > >+	case MFB_GET_PIXFMT:
> > >+		if (!arg)
> > >+			return -EINVAL;
> 
> This if (!arg) appears to be everywhere except default: label, maybe
> this could be placed on top too?
Will do that, too.

York

