Return-Path: <linux-kernel-owner+w=401wt.eu-S1762067AbXGFDBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762067AbXGFDBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 23:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760154AbXGFDBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 23:01:08 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:22016 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759645AbXGFDBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 23:01:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=bIHQ9kUhnwp46RIg7uZLxXNzUb/j5UarKkHBVKiPJfBtb2TQYGLgMBO10UIcF+NdDltXlDFCzBsgjjujfPcscOsvLODW4trh1TVPCunuob9nIpZrEKpWJnPzVIqOWGO5+mOVA3GodxPPayWqGv/Nh1afPYIiqjNaR/guSCFVWGY=
Date: Fri, 6 Jul 2007 11:03:21 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, rolandd@cisco.com,
       mshefty@ichips.intel.com, halr@voltaire.com,
       Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Steve Wise <swise@opengridcomputing.com>
Subject: Re: [-mm Patch] INFINIBAND: check the return value of kmalloc
Message-ID: <20070706030321.GA2191@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070704163741.GA2510@localhost.localdomain> <9a8748490707041700q18608e3ave4465f1181b97e2f@mail.gmail.com> <ada1wfm4jea.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada1wfm4jea.fsf@cisco.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 02:42:37PM -0700, Roland Dreier wrote:
>thanks, I added Jesper's suggestion to the original patch and queued
>this for 2.6.23:
>
>(Steve, let me know if this looks OK or not to you)
>
>commit 8d339921a2cb279457dce79f8a308978e0b41b27
>Author: WANG Cong <xiyou.wangcong@gmail.com>
>Date:   Thu Jul 5 14:40:32 2007 -0700
>
>    RDMA/cxgb3: Check return of kmalloc() in iwch_register_device()
>    
>    Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>    [ Also remove cast from void * return of kmalloc() as suggested by
>      Jesper Juhl <jesper.juhl@gmail.com>. ]
>    Signed-off-by: Roland Dreier <rolandd@cisco.com>
>

Very neat. Thanks!

