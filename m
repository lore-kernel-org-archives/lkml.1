Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbYGVHRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbYGVHRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 03:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYGVHQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 03:16:49 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:37785 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbYGVHQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 03:16:48 -0400
Message-ID: <488589E6.5070300@keyaccess.nl>
Date: Tue, 22 Jul 2008 09:19:02 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, arjan@infradead.org
Subject: Re: [RFC] Imprecise timers.
References: <1216695757.18980.16.camel@shinybook.infradead.org>
In-Reply-To: <1216695757.18980.16.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22-07-08 05:02, David Woodhouse wrote:

> Many users of timers don't really care too much about exactly when
> their timer fires -- and waking a CPU to satisfy such a timer is a
> waste of power. This patch implements a 'range' timer which will fire
> at a 'convenient' moment within given constraints.
> 
> It's implemented by a deferrable timer at the beginning of the range,
> which will run some time later when the CPU happens to be awake. And
> a non-deferrable timer at the hard deadline, to ensure it really does
> happen by then.

Are there actually users for this (not just in theory)? The deferrable 
timer sort of sounds like all I'd ever want if I, as you say, wouldn't 
really care...

Rene.
