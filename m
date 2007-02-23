Return-Path: <linux-kernel-owner+w=401wt.eu-S1752163AbXBWIM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbXBWIM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 03:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbXBWIM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 03:12:57 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:42823 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbXBWIM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 03:12:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=gF18rO9o6eRZCsZOBdxzokndxWZAHDHrK5Ta7nqkJzUUM/P/M2MEXAmvEFcuo2m5K9emcSt09/CNxFwcEaxntW1H/sDg/wb935WsHPF5DO04YtZE2xJ2MFtemjECr0S18HqA4n0Ey5dNJg0y1AlbszYnvg9EOdWKdIM9h39W8E4=
Date: Fri, 23 Feb 2007 11:10:05 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB Elan FTDI: check for workqueue creation
Message-ID: <20070223081005.GB10055@cvg>
References: <20070219181549.GB10111@cvg> <20070222155523.53e649a3.zaitcev@redhat.com> <20070223075322.GA10055@cvg> <20070222235738.f36e534a.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070222235738.f36e534a.zaitcev@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 11:57:38PM -0800, Pete Zaitcev wrote:
| On Fri, 23 Feb 2007 10:53:22 +0300, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > | > -static struct workqueue_struct *status_queue;
| > | > +static struct workqueue_struct *status_queue = NULL;
| 
| > | You better drop this part. Someone is bound to object.
| 
| > actually I don't understand why... Event on ftdi_elan_exit()
| > status_queue is setting up to NULL. And what is bound to object?
| > Could you write more detailed?
| 
| All these variables are static, they are already initialized to zero.
| 
| -- Pete
| 

Pete,

I may be wrong, but a lot of the kernel code have static pointers
initialized to NULL with explicit manner... More over I always thought
that _static_ is not mean _initialized to zero_. I think _static_ is
just the method to _hide_ variables in the file (as ANSI C describes).
Am I wrong?

		Cyrill

