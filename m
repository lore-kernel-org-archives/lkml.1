Return-Path: <linux-kernel-owner+w=401wt.eu-S1946129AbXBIW6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946129AbXBIW6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946135AbXBIW6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:58:11 -0500
Received: from nikam-dmz.ms.mff.cuni.cz ([195.113.20.16]:59493 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946129AbXBIW6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:58:04 -0500
Date: Fri, 9 Feb 2007 23:58:01 +0100
From: Martin Mares <mj@ucw.cz>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
Message-ID: <mj+md-20070209.225624.24301.nikam@ucw.cz>
References: <Pine.LNX.4.64.0702081324090.8424@woody.linux-foundation.org> <Pine.LNX.4.64.0702081432320.27603@chino.kir.corp.google.com> <Pine.LNX.4.64.0702081528070.8424@woody.linux-foundation.org> <Pine.LNX.4.64.0702081554380.29559@chino.kir.corp.google.com> <Pine.LNX.4.64.0702081632200.8424@woody.linux-foundation.org> <Pine.LNX.4.61.0702091330380.31955@yvahk01.tjqt.qr> <Pine.LNX.4.61.0702090755530.7642@chaos.analogic.com> <Pine.LNX.4.61.0702091842450.31955@yvahk01.tjqt.qr> <Pine.LNX.4.61.0702091509360.8711@chaos.analogic.com> <Pine.LNX.4.61.0702092247430.31955@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0702092247430.31955@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> void* comparisons are unsigned. Period.

As far as the C standard is concerned, there is no relationship between
comparison on pointers and comparison of their values casted to uintptr_t.
The address space needn't be linear and on some machines it isn't. So
speaking about signedness of pointer comparisons doesn't make sense,
except for concrete implementations.

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
Top ten reasons to procrastinate: 1.
