Return-Path: <linux-kernel-owner+w=401wt.eu-S933014AbXCFImo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbXCFImo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 03:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933040AbXCFImo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 03:42:44 -0500
Received: from smtp23.orange.fr ([193.252.22.30]:7528 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933014AbXCFImn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 03:42:43 -0500
X-ME-UUID: 20070306084241444.6C6087008BEE@mwinf2329.orange.fr
Subject: Re: [ck] Re: [ANNOUNCE] RSDL completely fair starvation free
	interactive cpu scheduler
From: Xavier Bestel <xavier.bestel@free.fr>
To: Con Kolivas <kernel@kolivas.org>
Cc: Al Boldi <a1426z@gawab.com>,
       Markus =?ISO-8859-1?Q?T=F6rnqvist?= <mjt@nysv.org>,
       ck list <ck@vds.kolivas.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200703060910.06343.kernel@kolivas.org>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703052329.45217.kernel@kolivas.org>
	 <200703052123.01095.a1426z@gawab.com>
	 <200703060910.06343.kernel@kolivas.org>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 09:42:34 +0100
Message-Id: <1173170554.5835.385.camel@frg-rhel40-em64t-03>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 09:10 +1100, Con Kolivas wrote:
> Hah I just wish gears would go away. If I get hardware where it runs at just 
> the right speed it looks like it doesn't move at all. On other hardware the 
> wheels go backwards and forwards where the screen refresh rate is just 
> perfectly a factor of the frames per second (or something like that). 
> 
> This is not a cpu scheduler test and you're inferring that there are cpu 
> scheduling artefacts based on an application that has bottlenecks at 
> different places depending on the hardware combination. 

I'd add that Xorg has its own scheduler (for X11 operations, of course),
that has its own quirks, and chances are that it is the one you're
testing with glxgears. And as Con said, as long as glxgears does more
FPS than your screen refresh rate, its flickering its completely
meaningless: it doesn't even attempt to sync with vblank. Al, you'd
better try with Quake3 or Nexuiz, or even Blender if you want to test 3D
interactivity under load.

	Xav


