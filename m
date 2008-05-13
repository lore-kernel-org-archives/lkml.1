Return-Path: <linux-kernel-owner+w=401wt.eu-S1756952AbYEMKzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952AbYEMKzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 06:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYEMKz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 06:55:28 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:56800 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYEMKz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 06:55:28 -0400
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rob Landley" <rob@landley.net>
Subject: Re: [RFC/PATCH] printk: detect incomplete lines
From: Andi Kleen <andi@firstfloor.org>
References: <20080512114925.GA29407@damson.getinternet.no>
	<84144f020805120456r14436eend416e079ea88be9c@mail.gmail.com>
	<19f34abd0805120500k7613dbd9le1bf79f7bb96778a@mail.gmail.com>
Date: Tue, 13 May 2008 12:54:23 +0200
In-Reply-To: <19f34abd0805120500k7613dbd9le1bf79f7bb96778a@mail.gmail.com> (Vegard Nossum's message of "Mon, 12 May 2008 14:00:07 +0200")
Message-ID: <87ej86scdc.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 May 2008 10:47:24.0361 (UTC) FILETIME=[BA729B90:01C8B4E6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Vegard Nossum" <vegard.nossum@gmail.com> writes:
>
> Iirc, KERN_CONT is mostly an annotation for the checkpatch script to
> suppress the warning about missing loglevel token.

Perhaps it should be fixed to contain some magic token that is 
then detected by printk and handled appropiately? And then perhaps
employee some kernel janitors to add it everywhere?

I think that would be preferable over any heuristics as implemented
in your original patch because there might be a legitimate need to
get out non full line printks ASAP for debugging.

-Andi
