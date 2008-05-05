Return-Path: <linux-kernel-owner+w=401wt.eu-S1760112AbYEET4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112AbYEET4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbYEET4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:56:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48958 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbYEET4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:56:34 -0400
Date: Mon, 5 May 2008 12:56:20 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Parag Warudkar <parag.warudkar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "akpm@osdl.org" <akpm@osdl.org>, Peter Zijlstra <peterz@infradead.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] default to n for GROUP_SCHED and FAIR_GROUP_SCHED
Message-ID: <20080505125620.219c4bb6@infradead.org>
In-Reply-To: <20080505184235.GD22332@elte.hu>
References: <82e4877d0805031742o464dd581wd93173d79705ce0d@mail.gmail.com>
	<20080504092417.GA3425@elte.hu>
	<82e4877d0805050814j721ae522k84384df48c9f4336@mail.gmail.com>
	<20080505171501.GA22332@elte.hu>
	<20080505182427.GA2025@uranus.ravnborg.org>
	<20080505184235.GD22332@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008 20:42:35 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> In practice distro maintainers will pick the upstream default 99% of
> the time, 

actually.. not quite. They don't tend to look at "default" in Kconfig;
they tend to say "m" if possible, and otherwise read the help text to
see if it makes sense...
