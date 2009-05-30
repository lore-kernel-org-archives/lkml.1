Return-Path: <linux-kernel-owner+w=401wt.eu-S1759959AbZE3Kpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959AbZE3Kpi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 06:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbZE3Kpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 06:45:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45285 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753791AbZE3Kpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 06:45:30 -0400
Date: Sat, 30 May 2009 11:46:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vvscore@gmail.com
Subject: Re: [PATCH] 8250: Fix oops from setserial
Message-ID: <20090530114632.7f101b9a@lxorguk.ukuu.org.uk>
In-Reply-To: <20090530014311.93577673.akpm@linux-foundation.org>
References: <20090528130132.19582.65165.stgit@t61.ukuu.org.uk>
	<20090529205429.c9c73b19.akpm@linux-foundation.org>
	<20090530092557.57578dd5@lxorguk.ukuu.org.uk>
	<20090530014311.93577673.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sure, huge numbers of drivers use the cast.
> 
> But I've never seen past sinnings as being a reason to continue sinning. 
> Doing new code the right way doesn't result in worse code, and reduces
> the chances of someone copying and pasting the wrong way.

As I said please read the rest of the driver. It would ridiculous to have
one dereference done differently to the rest in several thousand lines of
code.

It's not a new driver, it's simply pasting a line from one place to
another to update a field.

