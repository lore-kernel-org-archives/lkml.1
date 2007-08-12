Return-Path: <linux-kernel-owner+w=401wt.eu-S965127AbXHLULk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965127AbXHLULk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 16:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938232AbXHLULY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 16:11:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937969AbXHLULW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 16:11:22 -0400
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] Linux Kernel Markers - Documentation
References: <20070812151052.704221166@polymtl.ca>
	<20070812151221.048605202@polymtl.ca>
From: fche@redhat.com (Frank Ch. Eigler)
Date: 12 Aug 2007 16:11:10 -0400
In-Reply-To: <20070812151221.048605202@polymtl.ca>
Message-ID: <y0my7ggldi9.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.0808 (Gnus v5.8.8) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:

> [...]
> +A marker placed in your code provides a hook to call a function (probe) that
> +you can provide at runtime. A marker can be "on" (a probe is connected to it)
> +or "off" (no probe is attached). When a marker is "off" it has no
> +effect. [...]

Add something like, ", except for a (how?) small time/space penalty."

> +[...]
> +trace_mark(subsystem_event, "%d %s", someint, somestring);
> +Where :
> +- subsystem_event is an identifier unique to your event
> +    - subsystem is the name of your subsystem.
> +    - event is the name of the event to mark.
> +[...]

It would be useful to clarify that this "subsystem_event" scheme is
only a suggested naming convention intended to limit collisions.

> +Connecting a function (probe) to a marker is done by providing a
> probe +(function to call) for the specific marker through
> marker_probe_register() and +can be activated by calling
> marker_arm().

It would help to spell out the nature of the marker namespace.  Is it
global to the kernel?  Per-module?  Are conflicting "subsystem_event"
names but different format strings considered separate markers?

> + [...] Marker disactivation [...]

"deactivation"

- FChE
