Return-Path: <linux-kernel-owner+w=401wt.eu-S932278AbXBNNa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbXBNNa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 08:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932272AbXBNNa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 08:30:58 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50879 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932278AbXBNNa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 08:30:57 -0500
Date: Wed, 14 Feb 2007 14:30:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: Robin Holt <holt@sgi.com>, akpm@osdl.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, alan@lxorguk.ukuu.org.uk,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 0/4] coredump: core dump masking support v2
Message-ID: <20070214133042.GJ22008@elf.ucw.cz>
References: <45BA0A93.30004@hitachi.com> <20070126152907.GB30950@lnx-holt.americas.sgi.com> <45BEF582.7080004@hitachi.com> <20070130124417.GA7320@lnx-holt.americas.sgi.com> <45C08E33.9030300@hitachi.com> <20070203124853.GA4191@elf.ucw.cz> <45D30DEA.4020309@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D30DEA.4020309@hitachi.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Can we simply add ulimit with boolean value, that says dump
> > anon_shared... or not? It will be simpler and faster, because you'll
> > not need locking.
> 
> Yes, using ulimit will be simpler and faster, but less flexible.

It is prefered in this case.

> The core dump flags can be changed only before running the program.
> If the user modifies the program, the user will be able to change the
> flags anytime. But the user can't always modify the program.

You can do ulimit then exec from wrapper.

> I need the ability to change the core dump flags anytime.

Then maybe right solution is to extend _ulimit_ to change anything
anytime. But that's definitely separate patch.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
