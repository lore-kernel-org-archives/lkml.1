Return-Path: <linux-kernel-owner+w=401wt.eu-S1758586AbZGCTqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586AbZGCTqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 15:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758005AbZGCTqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 15:46:48 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:39020 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142AbZGCTqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 15:46:47 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Bug Fix]: Do 32-bit table calculations in pre-processor
Date: Fri, 3 Jul 2009 14:46:46 -0500
User-Agent: KMail/1.9.9
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <ak@linux.intel.com>
References: <200907031314.36243.lkml@morethan.org> <4A4E57FA.4000609@goop.org> <4A4E5974.7030507@zytor.com>
In-Reply-To: <4A4E5974.7030507@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907031446.49085.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri July 3 2009, H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
> > 
> > Hm, well that does sound serious, but I think you're barking up the
> > wrong tree with this particular patch.
> > 
> 
> Well, if it changes behavior it's an indication that the version of gas
> he's using is broken (or possibly very old.)  What version is it?
> 

Whatever Gentoo was shipping with 4.1 - -
System and operator are down for lunch at the moment -
I'll look it up and reply soonest.

Scroll back up to my first post - it does make a difference
with this tool-chain - exactly difference expected if the
tool chain is doing 32-bit calculations.

And since it is a "*.S" file - I think cpp is doing it not gas/as.

Mike
> 	-hpa
> 


