Return-Path: <linux-kernel-owner+w=401wt.eu-S1763769AbZFKXbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763769AbZFKXbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 19:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759719AbZFKXbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 19:31:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37493 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758212AbZFKXba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 19:31:30 -0400
Date: Thu, 11 Jun 2009 19:31:25 -0400
From: Dave Jones <davej@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Dominik Brodowski <linux@brodo.de>
Subject: Re: [PATCH 2/6] cpumask: avoid playing with cpus_allowed in
	speedstep-ich.c
Message-ID: <20090611233125.GB32486@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Rusty Russell <rusty@rustcorp.com.au>, cpufreq@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
	Dominik Brodowski <linux@brodo.de>
References: <20090611225927.E324ADDD04@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611225927.E324ADDD04@ozlabs.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 10:59:58PM +0930, Rusty Russell wrote:


Minor nit (and this was there before your change, but because
you moved it, checkpatch now whines..)

 > +static void get_freqs_on_cpu(void *_get_freqs)
 > +{
 > +	struct get_freqs *get_freqs = _get_freqs;
 > +
 > +	get_freqs->ret =
 > +		speedstep_get_freqs(speedstep_processor,
 > +				    &speedstep_freqs[SPEEDSTEP_LOW].frequency,
 > +				    &speedstep_freqs[SPEEDSTEP_HIGH].frequency,
 > +				    &get_freqs->policy->cpuinfo.transition_latency,
 > +				    &speedstep_set_state);
 > +}

line over 80 characters. 
I'll just pull it back one tab.

Perhaps some variable renaming in this file is called for to reduce
some of the redundancy in such lines.

	Dave

