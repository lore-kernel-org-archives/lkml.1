Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbXKXSJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbXKXSJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 13:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXKXSJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 13:09:49 -0500
Received: from mfe1.polimi.it ([131.175.12.23]:56645 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752841AbXKXSJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 13:09:48 -0500
Date: Sat, 24 Nov 2007 19:09:15 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, mb@bu3sch.de, mingo@elte.hu
Subject: Re: [BUG] jiffies counter leaps in 2.6.24-rc3
Message-ID: <20071124190915.4c1a8be4@morte>
In-Reply-To: <E1IvzFR-0001am-3J@faramir.fjphome.nl>
References: <20071124175112.58193424@morte>
	<E1IvzFR-0001am-3J@faramir.fjphome.nl>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.311128, Antispam-Data: 2007.11.6.30824
X-PerlMx-Spam: Gauge=IIIIIII, Probability=7%, Report='BODY_SIZE_600_699 0, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Nov 2007 18:56:57 +0100
Frans Pop <elendil@planet.nl> wrote:

> Stefano Brivio wrote:
> > It looks like the jiffies counter sometimes jumps back and forth of some
> > hundreds seconds in 2.6.24-rc3. I observed that this happens when I use
> > the su(1) command, e.g.:
> 
> Can you please explain what exactly the problem is here?
> 
> Are you perhaps referring to the number between square brackets for the su
> log lines? In that case there is no problem as in that case the number is
> not jiffies, but the process ID (PID) of the su process...

Sorry guy but I'm not _that_ idiot. Please notice jiffies values before and
after that.


-- 
Ciao
Stefano
