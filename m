Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053AbXAXRa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbXAXRa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 12:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbXAXRa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 12:30:26 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:52582
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbXAXRaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 12:30:25 -0500
From: Rob Landley <rob@landley.net>
To: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] sed s/gawk/awk/ scripts/gen_init_ramfs.sh
Date: Wed, 24 Jan 2007 12:30:40 -0500
User-Agent: KMail/1.9.1
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
References: <200701151624.18033.rob@landley.net> <20070115221146.GA12698@uranus.ravnborg.org> <20070123164944.db8acbad.akpm@osdl.org>
In-Reply-To: <20070123164944.db8acbad.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701241230.40996.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 January 2007 7:49 pm, Andrew Morton wrote:
> If the kernel is being compiled on a non-Linux system (eg: legacy Unix)
> then it is, I guess, possible for `awk' and `gawk' to offer different
> features.  If the kernel's use of gawk uses GNU extensions then this patch
> might break things on such a system.
> 
> I guess we'll find out...

I think we can rule out the "print $6" and "print $11" as gnu extensions.  And 
sub() is in the Single Unix Specification v3 spec for awk:

http://www.opengroup.org/onlinepubs/009695399/utilities/awk.html

I've used the busybox version and it worked just fine, once the links were 
renamed.

Rob
-- 
"Perfection is reached, not when there is no longer anything to add, but
when there is no longer anything to take away." - Antoine de Saint-Exupery
