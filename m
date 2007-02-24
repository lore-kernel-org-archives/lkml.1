Return-Path: <linux-kernel-owner+w=401wt.eu-S933408AbXBXHPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408AbXBXHPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 02:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933409AbXBXHPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 02:15:21 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:6423 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933408AbXBXHPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 02:15:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=aooceimDeDTMhT5Lx9Dcv26c50pOA5l6RrnTxoOeVOXHxCRQzK0vX2ph+AAbGO/7iYqkDRRm/LKE7bKaaKbCeVSq4yPkqylgxOIU18l+SpfrzSYmOgUxM229tL6EDcn+ZUSGLgCVctVkmEctTP3KH/4qQCzw46lahB66ZtP5VoI=
Date: Sat, 24 Feb 2007 10:12:25 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB Elan FTDI: check for workqueue creation
Message-ID: <20070224071225.GA10139@cvg>
References: <20070219181549.GB10111@cvg> <20070222155523.53e649a3.zaitcev@redhat.com> <20070223075322.GA10055@cvg> <20070222235738.f36e534a.zaitcev@redhat.com> <20070223081005.GB10055@cvg> <20070223174337.60d9ed3f.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223174337.60d9ed3f.zaitcev@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 05:43:37PM -0800, Pete Zaitcev wrote:
| On Fri, 23 Feb 2007 11:10:05 +0300, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > I may be wrong, but a lot of the kernel code have static pointers
| > initialized to NULL with explicit manner... More over I always thought
| > that _static_ is not mean _initialized to zero_. I think _static_ is
| > just the method to _hide_ variables in the file (as ANSI C describes).
| > Am I wrong?
| 
| I'm afraid you are wrong here. Static variables are initialized on
| zero in C, although I cannot provide you with a relevant quote from
| a standard. Just trust me for now, and resubmit the patch without
| the first segment... :-)  You're clearly fixing a bug in it.
| 
| -- Pete
| 

Hi Pete,

OK, I'll send a new one ;)

		Cyrill

