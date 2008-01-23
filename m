Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbYAWDCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbYAWDCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 22:02:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbYAWDBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 22:01:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955AbYAWDBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 22:01:50 -0500
To: mathieu.desnoyers@polymtl.ca
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Jon Masters <jcm@redhat.com>
Subject: Re: CONFIG_MARKERS
References: <1201029235.18144.62.camel@perihelion>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 22 Jan 2008 22:00:33 -0500
In-Reply-To: <1201029235.18144.62.camel@perihelion> (Jon Masters's message of "Tue, 22 Jan 2008 14:13:55 -0500")
Message-ID: <y0modbdnt4e.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jon Masters <jcm@redhat.com> writes:

> I notice in module.c:
>
> #ifdef CONFIG_MARKERS
> 	if (!mod->taints)
> 		marker_update_probe_range(mod->markers,
> 			mod->markers + mod->num_markers, NULL, NULL);
> #endif
>
> Is this an attempt to not set a marker for proprietary modules? [...]

I can't seem to find any discussion about this aspect.  If this is the
intent, it seems misguided to me.  There may instead be a relationship
to TAINT_FORCED_{RMMOD,MODULE}.  Mathieu?

- FChE
