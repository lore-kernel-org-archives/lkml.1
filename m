Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbYARKe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbYARKe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758052AbYARKdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:33:49 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:34832 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417AbYARKdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:33:47 -0500
Date: Fri, 18 Jan 2008 11:11:46 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC (Take 2)
Message-ID: <20080118054146.GA8973@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Michael Ellerman <michael@ellerman.id.au>,
	linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>
References: <20071207223714.11448.91386.sendpatchset@balbir-laptop> <1200634493.7806.0.camel@concordia.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1200634493.7806.0.camel@concordia.ozlabs.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Ellerman <michael@ellerman.id.au> [2008-01-18 16:34:53]:

> On Sat, 2007-12-08 at 04:07 +0530, Balbir Singh wrote:
> > Changelog
> > 
> > 1. Get rid of the constant 5 (based on comments from
> >                                 Geert.Uytterhoeven@sonycom.com)
> > 2. Implement suggestions from Olof Johannson
> > 3. Check if cmdline is NULL in fake_numa_create_new_node()
> > 
> > Tested with additional parameters from Olof
> > 
> > numa=debug,fake=
> > numa=foo,fake=bar
> 
> 
> I'm not sure why yet, but git bisect tells me it's this patch that's
> causing the for-2.6.25 tree to explode on boot on cell machines.
>

Hi,

Do you boot with numa=<options> on your machine? Could I have your
machine configuration? Any OOPS/log would be helpful.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
