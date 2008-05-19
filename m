Return-Path: <linux-kernel-owner+w=401wt.eu-S1761296AbYESTC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761296AbYESTC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 15:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbYESTCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 15:02:18 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:55412 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbYESTCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 15:02:18 -0400
Date: Mon, 19 May 2008 21:02:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] decodecode: use cross-compiler/toolchain if defined
Message-ID: <20080519190256.GA24599@uranus.ravnborg.org>
References: <20080512135242.GA5014@damson.getinternet.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080512135242.GA5014@damson.getinternet.no>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 03:52:42PM +0200, Vegard Nossum wrote:
> Hi Sam,
> 
> Not sure if this is really in the kbuild domain, but I see you've taken
> patches to this script before, so I'll make an attempt too :-)

Fine - and thanks for the reminder (in private mail).

> 
> Vegard
> 
> 
> From 75166add6121dbda4fad2e197d4fe6525dee580c Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Mon, 12 May 2008 15:36:38 +0200
> Subject: [PATCH] decodecode: use cross-compiler/toolchain if defined
> 
> From the Makefile: "CROSS_COMPILE specify [sic] the prefix used for all
> executables used".
> 
> This is also very useful for decoding oopses on other archs than the
> native one, so it seems natural to have it in the decodecode script as
> well.

I agree with the intent of this patch.
But as it is my experience that most people use
CROSS_COMPILE on the commandline and not as an
environmnet variable most will not benefit from this patch.

We should as a minimum document this use of decodecode where we
document its usage today (oops-tracing.txt).

We could also make it a Makefile target thus it is a bit
more natural to supply the typical Makefile parameters?

Please rework one way or the other.

	Sam
