Return-Path: <linux-kernel-owner+w=401wt.eu-S1761191AbYDYLZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761191AbYDYLZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 07:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYDYLZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 07:25:05 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:47156 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbYDYLZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 07:25:03 -0400
Message-ID: <4811BF53.6010408@s5r6.in-berlin.de>
Date: Fri, 25 Apr 2008 13:24:03 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Nico Schottelius 
	<nico-lkml-where-to-put-mouse-drivers@schottelius.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Where to put mouse drivers?
References: <20080424153743.GC4236@denkbrett.schottelius.org>
In-Reply-To: <20080424153743.GC4236@denkbrett.schottelius.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nico Schottelius wrote:
> I am currently wondering, how and where to continue with gpm2.
...
> http://nico.schottelius.org/notizbuch-blog/archive/2008/04/24/where-to-put-mouse-drivers

>From this page:
: So the idea with gpm2 was to make it run on all the standard FOSS
: operating systems (this includes Linux, FreeBSD, NetBSD and OpenBSD
: for me) and implement the mouse de/encoding part cleanly into it.
:
: Now I met the guys from the ggi-team, which aim to use the
: os-mous-support (like wscons or /dev/input/mice).
:
: The problem I see with that approach is that each OS reimplements
: the same stuff again and again. Which is exactly what I do not like.
:
: In my opinion the OS should offer direct access to the hardware
: ports of the mice (like serial devices and ps2 devices) and do the
: de/encoding stuff in userland, which would be portable then.

So you looked at GGI already.  And how about X11, e.g. x.org?  Or SDL?

Of course these projects also have to handle other input devices besides
pointing devices (keyboards, notably) and graphics output, maybe also
sound output.  Their approaches towards pointing devices are influenced
by how the other input and output interfaces are conceived.  And they do
use a variety of backends with widely differing degrees of hardware
abstraction (e.g. run on top of X11 or on top of VNC, instead of kernel
interfaces).

You on the other hand only deal with pointing device input and console
output, so you will probably come to different conclusions.
-- 
Stefan Richter
-=====-==--- -=-- ==--=
http://arcgraph.de/sr/
