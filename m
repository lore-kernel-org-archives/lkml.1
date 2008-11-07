Return-Path: <linux-kernel-owner+w=401wt.eu-S1753049AbYKGNkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbYKGNkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 08:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbYKGNkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 08:40:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55054 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbYKGNkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 08:40:08 -0500
Date: Fri, 7 Nov 2008 08:38:56 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       menage@google.com, ngupta@google.com, Rik van Riel <riel@redhat.com>,
       Jeff Moyer <jmoyer@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
Message-ID: <20081107133856.GA21884@redhat.com>
References: <20081106153022.215696930@redhat.com> <4913A9C2.8060904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4913A9C2.8060904@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 10:36:50AM +0800, Gui Jianfeng wrote:
> vgoyal@redhat.com wrote:
> > Hi,
> > 
> > If you are not already tired of so many io controller implementations, here
> > is another one.
> > 
> > This is a very eary very crude implementation to get early feedback to see
> > if this approach makes any sense or not.
> > 
> > This controller is a proportional weight IO controller primarily
> > based on/inspired by dm-ioband. One of the things I personally found little
> > odd about dm-ioband was need of a dm-ioband device for every device we want
> > to control.  I thought that probably we can make this control per request
> > queue and get rid of device mapper driver. This should make configuration
> > aspect easy.
> > 
> > I have picked up quite some amount of code from dm-ioband especially for
> > biocgroup implementation.
> > 
> > I have done very basic testing and that is running 2-3 dd commands in different
> > cgroups on x86_64. Wanted to throw out the code early to get some feedback.
> > 
> > More details about the design and how to are in documentation patch.
> > 
> > Your comments are welcome.
> 
>   Which kernel version is this patch set based on?
> 

2.6.27

Thanks
Vivek
