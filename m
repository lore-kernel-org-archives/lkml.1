Return-Path: <linux-kernel-owner+w=401wt.eu-S932068AbXBMX4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbXBMX4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 18:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932069AbXBMX4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 18:56:09 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:46904 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932068AbXBMX4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 18:56:08 -0500
Date: Tue, 13 Feb 2007 15:55:41 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Vojtech Pavlik <vojtech@suse.cz>
cc: Andi Kleen <ak@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Jiri Bohac <jbohac@suse.cz>, linux-kernel@vger.kernel.org,
       ssouhlal@freebsd.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: Re: [patch 4/9] Remove the TSC synchronization on SMP machines
In-Reply-To: <20070213221848.GF9189@suse.cz>
Message-ID: <Pine.LNX.4.64.0702131553560.30023@schroedinger.engr.sgi.com>
References: <20070201095952.589234000@jet.suse.cz>
 <1171348808.12771.19.camel@laptopd505.fenrus.org>
 <Pine.LNX.4.64.0702130906530.23634@schroedinger.engr.sgi.com>
 <200702131820.15180.ak@suse.de> <20070213221848.GF9189@suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007, Vojtech Pavlik wrote:

> The interaction with ntpd can be fixed and I've done it in the past
> once, although the fix wasn't all that nice.

It can be and was fixed by gradually moving time instead of jumping to 
the new time. F.e. the time interpolator on ia64 gradually adapts the 
intervals so that synchronization is obtained.

