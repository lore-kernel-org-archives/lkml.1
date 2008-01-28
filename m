Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbYA1I1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbYA1I1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 03:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYA1I1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 03:27:39 -0500
Received: from embla.aitel.hist.no ([158.38.50.22]:59528 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbYA1I1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 03:27:39 -0500
Message-ID: <479D91BE.7050503@aitel.hist.no>
Date: Mon, 28 Jan 2008 09:26:38 +0100
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
References: <20080125071127.GA4860@kroah.com>	 <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org>	 <20080125185213.GA23475@suse.de>	 <alpine.LFD.1.00.0801251108480.2979@hp.linux-foundation.org>	 <479A3ED3.6020808@goop.org> <1201296027.32422.80.camel@perihelion>	 <alpine.LFD.1.00.0801251347010.5056@hp.linux-foundation.org>	 <479A5B72.6080701@goop.org> <1201299979.27573.11.camel@lappy>
In-Reply-To: <1201299979.27573.11.camel@lappy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> My wish is that distros would just boot without requiring an initrd. I
> know how to make them for redhat and debian based distros, but the fact
> that you can't (easily) cross-build them makes it a very tedious
> construct.
>   
Debian is easy enough - make sure the drivers for the root
device and root fs is built-in, and you can drop the initrd.
Takes a second or two off the boot, and some more off the build.

Helge Hafting
