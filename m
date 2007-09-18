Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbXIRXBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbXIRXBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 19:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbXIRXBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 19:01:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbXIRXBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 19:01:46 -0400
Date: Tue, 18 Sep 2007 19:00:58 -0400
From: Alan Cox <alan@redhat.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jelle Foks <jelle@foks.8m.com>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Message-ID: <20070918230058.GA17234@devserv.devel.redhat.com>
References: <20070913131353.GB26972@linuxtv.org> <d9def9db0709130712h108c7c1obfe24833f5dc27a1@mail.gmail.com> <46E95C54.4060502@gmail.com> <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com> <46E99F36.8090809@hauppauge.com> <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com> <20070914135237.GB19311@devserv.devel.redhat.com> <d9def9db0709140918m4eff0fe9if01c3383a3a5c3ce@mail.gmail.com> <46EF8A1F.7040309@foks.8m.com> <1190156165.7883.24.camel@areia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190156165.7883.24.camel@areia>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 07:56:05PM -0300, Mauro Carvalho Chehab wrote:
> proprietary format. This way, an userspace app may use the userspace
> library as a "fallback method" for unknown FOURCC formats. The result
> will be probably far away from an optimal result on some cases (since it
> probably mean double buffering), but this will at least allow userspace
> apps to work. As performance become an issue, the userspace app
> developer may use the GPL code at userspace API as a reference to write
> a proper optimized format driver for its apps.

You can dynamically load libraries based on constructed path names which
means you can write a simple library for media conversions which in turn
will try and open libv4l-format-ABCD.so for any format it doesn't know - and
thus is extensible

