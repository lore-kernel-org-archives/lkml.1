Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYJHTcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYJHTcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbYJHTca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:32:30 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:8326 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbYJHTca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:32:30 -0400
X-BigFish: VPS-20(zz98dR1447Rzzzzz2fh6bh62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <48ED0ABB.2040607@am.sony.com>
Date: Wed, 8 Oct 2008 12:32:11 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC - size tool for kernel build system
References: <48EBD268.50208@am.sony.com> <48ED0575.4060005@redhat.com>
In-Reply-To: <48ED0575.4060005@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Oct 2008 19:32:12.0184 (UTC) FILETIME=[8FCA1980:01C9297C]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> The kernel build system is supposed to be stateless, and integrating
> this with make would mess that up.

> If your goal is to get more people
> to use Bloatwatch
Not really.  Bloatwatch is a means to an end.  It's
only the end I care about, which is more visibility
into kernel size growth over time.

> so they don't make your job quite as difficult, it
> would probably be more appropriate to put a size analysis script in
> scripts/ (like checkpatch.pl) that looks at only the kernel you just
> built and generates thorough statistics in a format readable by both
> humans and Bloatwatch, preferably something easily diffed.

The intent would be to do as you describe (although I don't
really care if the format is readable by Bloatwatch).  I'm a
Bloatwatch proponent (I'm not the author), but this suggestion
doesn't really have anything to do with Bloatwatch.  Maybe I should
have avoided mentioning it in my initial post.

Having a make target to run the script is just
a method of making it as easy as possible to run it.
(Kind of like 'make checkstack' or 'make cscope')
checkpatch.pl is different in that it operates on something
not in the tree yet.  It doesn't make sense as a make target
so I don't think it's comparable.

Maybe it would be simpler to omit the baseline comparison
capability at first, and just focus on a canonical size
report (script and report format) for the kernel.

> Then
> developers could use that output in mailing list discussions without
> having to use Bloatwatch, but embedded developers who care about this
> enough to use Bloatwatch can be confident that they're working with the
> same numbers that the rest of us are discussing with the plain text on
> the lists.

Discussing the number with the plain text on the lists is
the ultimate goal.  My thinking is that I'd like it to
be used kind of like 'powertop' (except not as a runtime tool
but as a development-time tool).  The main intent is just
to give developers more information about how their changes
affect the kernel size.

Thanks for the feedback.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

