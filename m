Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbXCaVRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbXCaVRx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 17:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbXCaVRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 17:17:53 -0400
Received: from gw.goop.org ([64.81.55.164]:44922 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbXCaVRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 17:17:52 -0400
Message-ID: <460ECFF9.7000903@goop.org>
Date: Sat, 31 Mar 2007 14:17:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove the config option for the cs5530a_warm_reset()
 quirk
References: <20070330010559.2a232d9a.akpm@linux-foundation.org> <20070331205530.GZ14134@stusta.de> <460ECD13.4000603@goop.org> <20070331211130.GE14134@stusta.de>
In-Reply-To: <20070331211130.GE14134@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> I have no strong opinion regarding this - if it's agreed upon that it's 
> unlikely it will ever grow, I can also send an additional patch 
> simplifying it.

I haven't got any response from the original person who submitted this
patch.  It isn't clear to me whether this is a fix for some machine
that's in wide use, or a workaround for a prototype sitting on someone's
bench.

Andi has already accepted my more general patch which allows
intercepting the halt/reboot process in arbitrary ways (the machine_ops
patch), so that would seem to be a better way of handling this problem
if more cases arise.

    J
