Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbXEACSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbXEACSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 22:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbXEACSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 22:18:20 -0400
Received: from terminus.zytor.com ([192.83.249.54]:54344 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbXEACST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 22:18:19 -0400
Message-ID: <4636A332.2070101@zytor.com>
Date: Mon, 30 Apr 2007 19:17:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
References: <463698D5.20102@zytor.com> <20070501015115.GJ26601@redhat.com>
In-Reply-To: <20070501015115.GJ26601@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> 
> I don't really care, but I wonder what the point is of rewriting something
> that hardly ever gets notably changed, and is rarely (if ever?) a source
> of bugs.  It might be crufty old assembly, but it's worked well for years.
> 

Well, it hardly gets notably changed because it is a nightmare to get it
right, and when it is changed, it is likely to be a bug magnet.  The
sheer number of bugs I have found in the process of figuring out what
the current code is doing is pretty much evidence of that.  I'm
surprised fewer bugs are actually manifest, but I guess that shows how
little of the code is actually used.

The "solution" that people have been employing has been to require the
use of special bootloaders for different environments, which enter at
code32_start instead.  Hardly an improvement.

	-hpa
