Return-Path: <linux-kernel-owner+w=401wt.eu-S1760872AbYFESPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760872AbYFESPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbYFESP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:15:26 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:40849 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbYFESPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:15:25 -0400
To: Jeff Dike <jdike@addtoit.com>
Cc: dhazelton@enter.net, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/6] UML - Deal with host time going backwards
References: <20080603190235.GA9511@c2.user-mode-linux.org>
	<20080603123211.e129c222.akpm@linux-foundation.org>
	<200806031543.56864.dhazelton@enter.net>
	<878wxmfg99.fsf@hades.wkstn.nix>
	<20080603130709.fcf6a751.akpm@linux-foundation.org>
	<20080603210048.GA12182@c2.user-mode-linux.org>
	<4846A75E.40305@goop.org>
	<20080604193715.GA11943@c2.user-mode-linux.org>
	<4846F577.10603@goop.org>
	<20080605153008.GC7311@c2.user-mode-linux.org>
From: Nix <nix@esperi.org.uk>
Emacs: more boundary conditions than the Middle East.
Date: Thu, 05 Jun 2008 19:14:30 +0100
In-Reply-To: <20080605153008.GC7311@c2.user-mode-linux.org> (Jeff Dike's message of "Thu, 5 Jun 2008 11:30:08 -0400")
Message-ID: <87k5h392bd.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-CTc-dcc2-Metrics: hades 1031; Body=6 Fuz1=6 Fuz2=6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Jun 2008, Jeff Dike verbalised:
> Aha, I was looking at timer_* and not getting reasonable-looking
> results.  The one questionable aspect of this is that I need to pull
> in a new library (librt) and I wonder how many people don't have it
> installed...

It comes with glibc, and even ls uses it (for clock_gettime(), to
determine what format to use for date display).

I'd say using it is about as safe as can be.

> Anyway, the patch below seems to make the guest behave reasonably in
> the face of the host time doing funky things...
>
> Give it a spin and let me know how it does.  If there aren't any
> problems, I'll get it into mainline.

Rebuilding for a test now.

-- 
`If you are having a "ua luea luea le ua le" kind of day, I can only
 assume that you are doing no work due [to] incapacitating nausea caused 
 by numerous lazy demons.' --- Frossie
