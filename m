Return-Path: <linux-kernel-owner+w=401wt.eu-S932085AbXAaAmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbXAaAmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 19:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932088AbXAaAmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 19:42:46 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:39245 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbXAaAmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 19:42:46 -0500
Subject: Re: [PATCH 5/5] KVM: Host suspend/resume support
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
In-Reply-To: <200701302319.10369.rjw@sisk.pl>
References: <45BF5B96.1070007@qumranet.com>
	 <20070130145717.00D1BA0014@il.qumranet.com>
	 <1170192049.4308.16.camel@nigel.suspend2.net>
	 <200701302319.10369.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 11:42:43 +1100
Message-Id: <1170204163.3569.0.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, 2007-01-30 at 23:19 +0100, Rafael J. Wysocki wrote:
> On Tuesday, 30 January 2007 22:20, Nigel Cunningham wrote:
> > Hi.
> > 
> > On Tue, 2007-01-30 at 14:57 +0000, Avi Kivity wrote:
> > > Add the necessary callbacks to suspend and resume a host running kvm.  This
> > > is just a repeat of the cpu hotplug/unplug work.
> > > 
> > > Signed-off-by: Avi Kivity <avi@qumranet.com>
> > 
> > Maybe it's just a lack of understanding, but I'm wondering if this patch
> > is necessary - we already hot-unplug secondary cpus prior to suspending
> > devices.
> 
> Not with the reoredering patches that are in -mm, though.  With these patches,
> the nonboot CPUs are disabled after "regular" devices.

Ah. Good point. Thanks! :)

Nigel

