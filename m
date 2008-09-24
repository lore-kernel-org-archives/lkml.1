Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbYIXOXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbYIXOXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 10:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYIXOXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 10:23:31 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:23204 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYIXOXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 10:23:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WVk1XD+t+LIE1c2Pwh/cq4Z/zJju7kOuzwwWFX1E8PATID9nAZqp0cvGaH6FiVuJuD
         Gn6EMxW8RaXFYZSxt3pp3VY5HTsd+ei9XjEHh8Mg5T4p3fdSy+fokMK1syGsLhgEwB5w
         3xR3WWV7dm6Di9eNuJ8oWTYDzie2ipzsx/kKY=
Date: Wed, 24 Sep 2008 22:23:22 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: Cristi Magherusan <cristi.magherusan@net.utcluj.ro>
Cc: Yan Li <elliot.li.tech@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
Message-ID: <20080924142322.GA21049@yantp.cn.ibm.com>
References: <48D12490.5010003@zytor.com> <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com> <1222265424.5708.5.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222265424.5708.5.camel@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 05:10:24PM +0300, Cristi Magherusan wrote:
> On Wed, 2008-09-24 at 20:22 +0800, Yan Li wrote:
> > Detects whether we are running as a VMware guest or not. Detection is
> > based upon DMI vendor string.
> > 
> > It provides a function:
> > int is_vmware_guest(void)
> > that can be used easily to detect if we are running as a VMware guest
> > or not.
> 
> We can also use this feature to force the HZ value to 100 or 250 at most
> when running in a virtual environment, since VirtualBox had some issues
> with this by taking a lot of CPU time when the HZ was set to 1000.

That's good. But this function is used for detecting VMware guest
only.  Do you think VMware also suffers from this problem?

-- 
Li, Yan
