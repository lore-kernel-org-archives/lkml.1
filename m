Return-Path: <linux-kernel-owner+w=401wt.eu-S1422766AbXCGSDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422766AbXCGSDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422963AbXCGSDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:03:53 -0500
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:44301 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422766AbXCGSDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:03:43 -0500
Date: Wed, 7 Mar 2007 13:03:39 -0500 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Ingo Molnar <mingo@elte.hu>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, akpm@linux-foundation.org
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
In-Reply-To: <20070307174957.GA31371@elte.hu>
Message-ID: <Line.LNX.4.64.0703071303010.1851@d.namei>
References: <45EDD82F.90204@vmware.com> <1173225182.24738.507.camel@localhost.localdomain>
 <45EE0628.1080108@goop.org> <45EE08E8.2020008@vmware.com>
 <1173228544.24738.514.camel@localhost.localdomain> <45EE0D10.7070807@vmware.com>
 <1173230305.24738.529.camel@localhost.localdomain> <45EE1EA3.90803@vmware.com>
 <1173256666.24738.576.camel@localhost.localdomain> <45EEF966.6060902@goop.org>
 <20070307174957.GA31371@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007, Ingo Molnar wrote:

> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Xen, for example, uses the tsc as the principle timebase in the
> > hypervisor interface. [...]
> 
> ugh. Please take it from me: i've watched the Linux time code walk its 
> long, rocky 10+ years road. One of the first mistakes was when we made 
> the TSC the center of the i386-time universe. (incidentally, it was me 
> who did the first steps of that, as a rookie kernel hacker) We got cured 
> out of that in v2.6.19, v2.6.20 and v2.6.21. Granted, Xen is only at the 
> beginning of that same road. Meet in another 10 years? ;)

What do you suggest instead ?

(Digging into this for lguest now...)



- James
-- 
James Morris
<jmorris@namei.org>
