Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbZADMIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbZADMIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 07:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbZADMIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 07:08:12 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59589 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750795AbZADMIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 07:08:11 -0500
Date: Sun, 4 Jan 2009 12:07:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rob Landley <rob@landley.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3]: Replace kernel/timeconst.pl with
 kernel/timeconst.sh
Message-ID: <20090104120735.72840fdb@lxorguk.ukuu.org.uk>
In-Reply-To: <200901031932.51873.rob@landley.net>
References: <200901020207.30359.rob@landley.net>
	<200901020600.47847.rob@landley.net>
	<495E6BEE.1000805@zytor.com>
	<200901031932.51873.rob@landley.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I note that sed and printf and such are all susv3.  I have an explicit test 
> for 32 bit math in the script that cares, and this worked in Red Hat 9 circa 
> 2003.

If you are trying to do arbitary precision maths using standard posix
tools just use dc. That way the standard is explicit about what you will
get.
