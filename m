Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbXIFK20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbXIFK20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 06:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbXIFK2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 06:28:19 -0400
Received: from canuck.infradead.org ([209.217.80.40]:46862 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbXIFK2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 06:28:18 -0400
Subject: Re: [2/2] 2.6.23-rc5: known regressions with patches
From: David Woodhouse <dwmw2@infradead.org>
To: Satyam Sharma <satyam@infradead.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.0.999.0709061600250.3781@enigma.security.iitk.ac.in>
References: <46DBDCF4.6040805@googlemail.com>
	 <46DBDDC6.9030602@googlemail.com>
	 <1189072799.2745.68.camel@shinybook.infradead.org>
	 <alpine.LFD.0.999.0709061600250.3781@enigma.security.iitk.ac.in>
Content-Type: text/plain
Date: Thu, 06 Sep 2007 11:28:11 +0100
Message-Id: <1189074491.2745.78.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-3.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-06 at 16:04 +0530, Satyam Sharma wrote:
> You shouldn't push this even for 2.6.24 ... I can't see why/how a runtime
> BUG() scores over erroring out at build-time itself. And if there is no
> codepath that leads to that BUG() at runtime, then what's the point of
> adding dead code ...
>
> So I wonder if what you're actually looking for is some kind of Kconfig
> dependencies that will *prevent* the kind of .config from being generated
> that Ingo ran into ?

I looked at that but decided against it. There's too much hand-holding
and arbitrary 'automatic' crap in the Kconfig crap already, and I
couldn't see a way to do it that didn't make that worse.

As long as we no longer break randconfig builds, it'll be fine. It's not
as if people _run_ those kernels, let alone actually exercise the code
path in question.

-- 
dwmw2

