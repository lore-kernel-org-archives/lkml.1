Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbYBSQsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbYBSQsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 11:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbYBSQso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 11:48:44 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:58350 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbYBSQsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:48:43 -0500
Date: Tue, 19 Feb 2008 08:44:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Nick Andrew <nick@nick-andrew.net>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>
Subject: Re: Improve init/Kconfig help descriptions [PATCH 3/9]
Message-Id: <20080219084420.f3104e3f.randy.dunlap@oracle.com>
In-Reply-To: <47BAF2E5.8050001@openvz.org>
References: <20080219140609.GA26619@tull.net>
	<20080219143307.GA27352@tull.net>
	<47BAEABF.6050005@openvz.org>
	<20080219151028.GA28294@tull.net>
	<47BAF2E5.8050001@openvz.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 18:16:53 +0300 Pavel Emelyanov wrote:

> Nick Andrew wrote:
> > On Tue, Feb 19, 2008 at 05:42:07PM +0300, Pavel Emelyanov wrote:
> >> Nick Andrew wrote:
> >>> On Wed, Feb 20, 2008 at 01:06:09AM +1100, Nick Andrew wrote:
> >>>> Here is a series of 9 patches to init/Kconfig intended to improve the
> >>>> usefulness and consistency of the help descriptions. The patches are
> >>>> against linux-2.6.24.2.
> >>>> [...]
> >>>> Patch 3
> >>>> 	USER_NS
> >>>> 	PID_NS
> >> What about UTS_NS, IPC_NS and NET_NS? 
> >> Their descriptions can be improved in the same way :)
> > 
> > So far I have edited only init/Kconfig, that's what these 9
> > patches are for. Next I'll do block/Kconfig. Eventually I expect
> > to get to net/Kconfig which is where NET_NS is configured,
> > but I don't know where UTS_NS and IPC_NS come from in 2.6.24.2.
> > 
> > I expect I'll have to start patching against a git tree soon,
> > to be sure to see the latest code. I assume this should be
> > Linus' tree?
> 
> Both UTS_NS and IPC_NS are in init/Kconfg. At least they are
> in 2.6.25-rc2 :)

Yes, these patches should be made against the latest development
tree, not the stable tree.


---
~Randy
