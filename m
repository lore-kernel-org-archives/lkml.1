Return-Path: <linux-kernel-owner+w=401wt.eu-S1760883AbZFZRDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760883AbZFZRDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 13:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbZFZRDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 13:03:03 -0400
Received: from complete.lackof.org ([198.49.126.79]:44974 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbZFZRDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 13:03:02 -0400
Date: Fri, 26 Jun 2009 11:03:04 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-parisc@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31-rc1: parisc: multiple PCI BAR collisions
Message-ID: <20090626170304.GA20871@lackof.org>
References: <a4423d670906260158q15080049ue516c3d454f4afbf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670906260158q15080049ue516c3d454f4afbf@mail.gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 12:58:22PM +0400, Alexander Beregalov wrote:
> Hi
> 
> Hardware is HP j6000.
> It cannot initialize many PCI devices (sym53c8xx, tulip, STI,
> usb(onci)) and cannot boot (no root device).
> Messages like this:
> sym53c8xx 0:0:0f.0: device not available because of BAR 1 [0xf4005000
> - 0xf40053ff] collisions.

Yup - I found that out yesterday too. Console output is here:
http://iou.parisc-linux.org/~grundler/console/j6000-2.6.30-parisc_2.6_parenting_failed-01
http://iou.parisc-linux.org/~grundler/console/j6000-2.6.30-parisc_2.6_parenting_failed-02

but in an IRC conversation it' clear I only dumped the "elmmio" and not
the regular "lmmio" resource request. Need to dump both.

I'm pretty sure this is a problem of the root bus resources not getting
setup correctly. I'm not clear on what's wrong. jejb and willy are looking
at it now as well.

thanks,
grant
