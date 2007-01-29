Return-Path: <linux-kernel-owner+w=401wt.eu-S1750696AbXA2PXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750696AbXA2PXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 10:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbXA2PXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 10:23:45 -0500
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:42421 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbXA2PXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 10:23:44 -0500
Date: Mon, 29 Jan 2007 10:23:41 -0500 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Stephen Smalley <sds@tycho.nsa.gov>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH] sysctl selinux: Don't look at table->de
In-Reply-To: <1170075866.8720.15.camel@moss-spartans.epoch.ncsc.mil>
Message-ID: <Pine.LNX.4.64.0701291017520.11801@d.namei>
References: <200701280106.l0S16CG3019873@shell0.pdx.osdl.net> 
 <20070127172410.2b041952.akpm@osdl.org>  <1169972718.17469.164.camel@localhost.localdomain>
  <20070128003549.2ca38dc8.akpm@osdl.org> <20070128093358.GA2071@elte.hu> 
 <20070128095712.GA6485@elte.hu> <20070128100627.GA8416@elte.hu> 
 <20070128104548.a835d859.akpm@osdl.org>  <m1r6tfq7nv.fsf_-_@ebiederm.dsl.xmission.com>
 <1170075866.8720.15.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007, Stephen Smalley wrote:

> NAK.  Mapping all sysctls to a single security label prevents any kind
> of fine-grained security on sysctls, and current policies already make
> use of the current distinctions to limit access to particular sets of
> sysctls to particular processes.  As is, I'd expect breakage of current
> systems running SELinux from this patch, because (confined) processes
> that formerly only required access to specific sysctl labels will
> suddenly run into denials on the generic fallback label.

Agreed, 100% NACK.

Please don't just simply remove long-researched & analyzed MAC security 
which has been in the kernel for years, which is being used in the field 
for high assurance systems, because you neglected to consider it during a 
code cleanup.


- James
-- 
James Morris
<jmorris@namei.org>
