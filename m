Return-Path: <linux-kernel-owner+w=401wt.eu-S1759795AbXIKFOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795AbXIKFOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 01:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761315AbXIKFOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 01:14:42 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:32841 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650AbXIKFOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 01:14:41 -0400
Date: Tue, 11 Sep 2007 10:44:53 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-arch@vger.kernel.org,
       discuss@x86-64.org, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Bernhard Walle <bwalle@suse.de>
Subject: Re: [discuss] [patch 3/5] Use extended crashkernel command line on x86_64
Message-ID: <20070911051453.GB5053@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070909083914.065380136@strauss.suse.de> <20070909083914.951336895@strauss.suse.de> <86802c440709091027o32a63d11w629bad87abcc19c2@mail.gmail.com> <20070909185257.GA10600@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070909185257.GA10600@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2007 at 08:52:58PM +0200, Bernhard Walle wrote:
> * Yinghai Lu <yhlu.kernel@gmail.com> [2007-09-09 19:27]:
> > >
> > > +#ifdef CONFIG_KEXEC
> > ...
> > 
> > CONFIG_KEXEC or CONFIG_CRASH_DUMP?
> 
> Good question. The crashkernel parameter was CONFIG_KEXEC before, and
> I also wondered why, but I didn't change this because maybe there's
> some reason I don't know.
> 
> Vivek, do you know why this was CONFIG_KEXEC?
> 
> 

Bernhard,

As Eric mentioned, CONFIG_CRASH_DUMP has been used for all dump capturing
infrastructure and rest of the kexec and kexec on panic functionality
has been put under CONFIG_KEXEC. 

Keeping memory reservation under CONFIG_KEXEC helps in a sense when
somebody is not using a relocatable kernel and uses a custom kernel for dump
capture. In that case he does not have to enable CONFIG_CRASH_DUMP in the
first kernel.

Thanks
Vivek
