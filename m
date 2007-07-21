Return-Path: <linux-kernel-owner+w=401wt.eu-S1764421AbXGUUiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764421AbXGUUiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 16:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762151AbXGUUiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 16:38:06 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39082 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759817AbXGUUiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 16:38:05 -0400
Date: Sat, 21 Jul 2007 22:39:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Oleg Verych <olecom@flower.upol.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kbuild-devel] [PATCH 25/33] kbuild: use POSIX BRE in headers install target
Message-ID: <20070721203916.GA2912@uranus.ravnborg.org>
References: <11846813443187-git-send-email-sam@ravnborg.org> <1184681344985-git-send-email-sam@ravnborg.org> <11846813442810-git-send-email-sam@ravnborg.org> <118468134441-git-send-email-sam@ravnborg.org> <11846813441741-git-send-email-sam@ravnborg.org> <1184681344376-git-send-email-sam@ravnborg.org> <E1ICAEU-0005an-5F@flower> <8bd0f97a0707210127m565f9b2cnc7a8a203f671e948@mail.gmail.com> <20070721100422.GK475@flower.upol.cz> <8bd0f97a0707211221l2c7fedeoea8612876350db6d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0707211221l2c7fedeoea8612876350db6d@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 03:21:43PM -0400, Mike Frysinger wrote:
> On 7/21/07, Oleg Verych <olecom@flower.upol.cz> wrote:
> >On Sat, Jul 21, 2007 at 04:27:31AM -0400, Mike Frysinger wrote:
> >[]
> >> if you want to make some micro optimization in the build install step,
> >> sure ... but functionally, the difference is irrelevant considering
> >> sed operates only on individual lines
> >
> >That was an attempt to support less sucking userspace in the kernel
> >development. More readable, more memory/cpu effective, more portable.
> 
> while you could try and make a claim against memory/cpu effeciency, i
> fail to see how the first or last claims could possibly be backed up
> 
> but again, if you feel that strongly about it, you're certainly free
> to post a patch

I would much more prefer this functionality to be integrated into unifdef.
There is no good reason to have two different preprocesisng methonds, one
being the sed based one and the other the unidef one.

A sinlge dedicated program that contian the sum of the functionality would
be faster too.

	Sam
