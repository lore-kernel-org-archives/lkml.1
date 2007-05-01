Return-Path: <linux-kernel-owner+w=401wt.eu-S933388AbXEABvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388AbXEABvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 21:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933410AbXEABvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 21:51:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933388AbXEABvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 21:51:50 -0400
Date: Mon, 30 Apr 2007 21:51:15 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
Message-ID: <20070501015115.GJ26601@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andi Kleen <ak@suse.de>, Jeff Garzik <jeff@garzik.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Linus Torvalds <torvalds@osdl.org>
References: <463698D5.20102@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463698D5.20102@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 06:33:09PM -0700, H. Peter Anvin wrote:
 > Hi all,
 > 
 > I'm rewriting the i386 setup code in C, instead of assembly, and before
 > I spend a very large amount of time translating all the various
 > card-specific probes, I want to ask the following question...
 > 
 > Does *anyone* care about these anymore?
 > 
 > All of these are specific to cards from a very long time ago.  I am
 > currently planning to retain the VESA-related code, and the standard
 > video modes, but I'd like to avoid the card-specific stuff, especially
 > since I have absolutely zero ability to test any of testing them (with
 > the possible sole exception of the cirrus5 code, which is emulated by qemu.)
 > 
 > Please holler if you care...

I don't really care, but I wonder what the point is of rewriting something
that hardly ever gets notably changed, and is rarely (if ever?) a source
of bugs.  It might be crufty old assembly, but it's worked well for years.

	Dave

-- 
http://www.codemonkey.org.uk
