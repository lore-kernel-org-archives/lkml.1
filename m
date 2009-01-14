Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbZANCvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbZANCvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 21:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZANCvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 21:51:37 -0500
Received: from mail2.shareable.org ([80.68.89.115]:44801 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbZANCvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 21:51:35 -0500
Date: Wed, 14 Jan 2009 02:51:16 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Paul Mundt <lethal@linux-sh.org>, Sam Ravnborg <sam@ravnborg.org>,
       "Mark A. Miller" <mark@mirell.org>, Bernd Petrovitsch <bernd@firmix.at>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       Rob Landley <rob@landley.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Message-ID: <20090114025115.GB22154@shareable.org>
References: <495FEEAF.5020005@zytor.com> <200901032006.47652.rob@landley.net> <20090104030619.GA21466@linux-sh.org> <c384c5ea0901040223l6e53f041s9f7cdea20c9d1d8d@mail.gmail.com> <1231677939.3517.5.camel@gimli.at.home> <31014a580901111928u586e2246uccf370ff941c8a01@mail.gmail.com> <20090112053552.GA9061@uranus.ravnborg.org> <31014a580901112150x57cd715aj5f42ee19bc28c701@mail.gmail.com> <20090112101803.GB10086@uranus.ravnborg.org> <20090112103820.GF28564@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112103820.GF28564@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> This happens in a lot of places, like embedded gentoo ports, where almost
> all of the work is sent across distcc to a cross-compilation machine. In
> systems that use package management, it is done on the host through
> emulation, or painfully cross-compiled.

Ah yes, I remember using embedded Gentoo.

95% of the time in ./configure scripts, 5% in compilations.

And this is on x86!  I dread to think how slow it gets on something
slow.

-- Jamie
