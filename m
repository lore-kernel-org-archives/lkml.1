Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbXJXUrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbXJXUrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 16:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbXJXUrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 16:47:41 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:53728
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754636AbXJXUrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 16:47:40 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Jeff Dike <jdike@addtoit.com>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
Date: Wed, 24 Oct 2007 16:46:54 -0500
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
References: <200710111754.46854.rob@landley.net> <20071024152240.GA7733@c2.user-mode-linux.org>
In-Reply-To: <20071024152240.GA7733@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710241646.54942.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2007 10:22:40 am Jeff Dike wrote:
> I poked around a bit for a sparc cross-toolchain, didn't find one, so
> I couldn't see what exactly the problem was.

Prebuilt for Ubuntu 7.04:
http://landley.net/code/firmware/downloads/cross-compiler/host-i686/cross-compiler-sparc.tar.bz2

Source code:
Or http://landley.net/code/firmware/downloads/firmware-0.2.2.tar.bz2

For the second one, extract it, cd into it, "./build.sh sparc", and when it 
finishes your sparc-gcc should be in "build/cross-compiler-sparc/bin".

You can move the cross-compiler-sparc directory anywhere you want in the 
filesystem, and it should still work.  Just add the "bin" subdirectory of it 
to $PATH and CROSS_COMPILE=sparc-

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
