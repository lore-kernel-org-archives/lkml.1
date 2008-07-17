Return-Path: <linux-kernel-owner+w=401wt.eu-S1756278AbYGQGp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbYGQGp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 02:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYGQGpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 02:45:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60800 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbYGQGpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 02:45:49 -0400
Message-ID: <487EEA9B.4030808@firstfloor.org>
Date: Thu, 17 Jul 2008 08:45:47 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Please pull ACPI updates
References: <20080716214516.GA10777@basil.nowhere.org> <200807161633.01375.jbarnes@virtuousgeek.org> <alpine.LFD.1.10.0807161639090.2835@woody.linux-foundation.org> <200807161651.44990.jbarnes@virtuousgeek.org> <alpine.LFD.1.10.0807161728560.2835@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807161728560.2835@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 16 Jul 2008, Jesse Barnes wrote:
>>> Andi did not. The whole series I pulled was rebased today at 2PM.
>> Ugg, when Andi took over we talked about it; I thought we had agreed that he 
>> would stick with Len's tree.  I guess I was wrong.
> 
> Well, I haven't actually seen Len's original tree, so maybe the stuff Andi 
> pushed was just the stuff he had queued up independently. I guess I 
> shouldn't judge before I'm sure.

I originally started with topic branches and imported a few patches
this way, but then eventually realized they don't really match my
working style. In particular I tend to edit and sometimes
delete old patches and that seems to be quite painful with
the topic branch setup (or perhaps I just haven't figured out
how to do it nicely). Also tried it with guilt, but that
also ran into some issues (in particular after merges one
cannot manage the patches as a guilt stack anymore)

What I did then was to export Len's tree to quilt, do all the touchups
etc, merged some more patches and then regenerated a quilt tree for
the merge request. That is how the old x86-64 tree used to work.

-Andi
