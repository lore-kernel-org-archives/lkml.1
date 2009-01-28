Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbZA1K5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbZA1K5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 05:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZA1K5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 05:57:45 -0500
Received: from ozlabs.org ([203.10.76.45]:51327 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbZA1K5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 05:57:43 -0500
Date: Wed, 28 Jan 2009 21:56:01 +1100
From: Anton Blanchard <anton@samba.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] bootgraph: fix for use with dot symbols
Message-ID: <20090128105601.GB18368@kryten>
References: <19599.1233113450@neuling.org> <497FE4E7.8070303@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497FE4E7.8070303@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Arjan,

> question for the ppc folks.... why does the "print symbol" magic format string
> thing print a dot symbol and not the real function name?
> Should that be fixed instead?

We have two symbols for each function, foo points to the function
descriptor, and .foo points to the instruction text. If we were to strip
the '.' when we print symbols then it would become harder to diagnose
some failures (eg branching to the function descriptor instead of the
instruction text).

Anton
