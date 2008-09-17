Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbYIQVeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbYIQVeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 17:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbYIQVeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 17:34:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:32809 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbYIQVef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 17:34:35 -0400
Date: Wed, 17 Sep 2008 14:34:39 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: How how latent should non-preemptive scheduling be?
Message-ID: <20080917143439.5ce79534@infradead.org>
In-Reply-To: <48D1741A.7010508@yahoo.com>
References: <48D1741A.7010508@yahoo.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008 22:18:18 +0100
Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> Hi,
> 
> I have an EeePC 900 (Intel Celeron 900Mhz) and it seems to be
> skipping while playing sound through various desktop apps with a
> 2.6.27rc6 kernel. It is running off an SD card which really shows up
> slow writes but the sound is seemingly skipping even when ext3 is not
> being used. When look at latencytop I often see results similar to
> this:
> 
> > Cause                                                Maximum
> > Percentage Scheduler: waiting for cpu                        247.2
> > msec         64.6 % futex_wait do_futex sys_futex
> > sysenter_do_call      5.0 msec         24.8 % do_select
> > core_sys_select sys_select sysenter_do_c  4.7 msec          0.7 %
> > do_sys_poll sys_poll sysenter_do_call               4.5


this says you haven't done "make install" on the latencytop directory
so it's not translating things for you.. can you do that please?
