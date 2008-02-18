Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbYBRPQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbYBRPQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbYBRPP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:15:56 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46178 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbYBRPPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:15:54 -0500
Date: Mon, 18 Feb 2008 09:15:49 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Kohei KaiGai <kaigai@ak.jp.nec.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, akpm@osdl.org,
       "Andrew G. Morgan" <morgan@kernel.org>, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       adobriyan@gmail.com
Subject: Re: [PATCH] exporting capability code/name pairs (try #5.1)
Message-ID: <20080218151549.GD24864@sergelap.austin.ibm.com>
References: <47AC23F1.5030300@ak.jp.nec.com> <20080212180859.GA12876@sergelap.austin.ibm.com> <47B2A3F3.8060701@ak.jp.nec.com> <47B4ED1B.6070206@ak.jp.nec.com> <47B4F1C5.9010408@cn.fujitsu.com> <47B4FFE0.3000702@ak.jp.nec.com> <20080215183802.GA3925@sergelap.austin.ibm.com> <20080215185003.GA7495@kroah.com> <47B92FF5.1080301@ak.jp.nec.com> <20080218074056.GA19915@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218074056.GA19915@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Greg KH (greg@kroah.com):
> On Mon, Feb 18, 2008 at 04:12:53PM +0900, Kohei KaiGai wrote:
> > Greg KH wrote:
> > > On Fri, Feb 15, 2008 at 12:38:02PM -0600, Serge E. Hallyn wrote:
> > >>> --------
> > >>> This patch enables to export code/name of capabilities supported
> > >>> on the running kernel.
> > >>>
> > >>> A newer kernel sometimes adds new capabilities, like CAP_MAC_ADMIN
> > >>> at 2.6.25. However, we have no interface to disclose what capabilities
> > >>> are supported on this kernel. Thus, we have to maintain libcap version
> > >>> in appropriate one synchronously.
> > >>>
> > >>> This patch enables libcap to collect the list of capabilities on
> > >>> run time, and provide them for users.
> > >>> It helps to improve portability of library.
> > >>>
> > >>> It exports these information as regular files under /sys/kernel/capability.
> > >>> The numeric node exports its name, the symbolic node exports its code.
> > >>>
> > >>> Please consider to put this patch on the queue of 2.6.25.
> > >> Looks good, except don't you need to put the code in commoncap.c under a
> > >> #ifdef SYSFS?
> > 
> > Fair enough.
> > I added the #ifdef - #endif block in this patch.
> 
> Not needed, if SYSFS is not build in, all of that code pretty much
> compiles away to nothing.  So you can drop that.

Oops.  Sorry.

-serge
