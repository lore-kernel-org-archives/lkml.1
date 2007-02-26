Return-Path: <linux-kernel-owner+w=401wt.eu-S1030429AbXBZSoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030429AbXBZSoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 13:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030430AbXBZSoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 13:44:12 -0500
Received: from rwcrmhc15.comcast.net ([204.127.192.85]:44294 "EHLO
	rwcrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030429AbXBZSoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 13:44:11 -0500
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Feb 2007 13:44:11 EST
Subject: x86_64 vdso patch status?
From: Jim Houston <jim.houston@comcast.net>
Reply-To: jim.houston@comcast.net
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 26 Feb 2007 13:33:49 -0500
Message-Id: <1172514829.7749.17.camel@x2.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

I tried playing with your vdso patch.  I'm curious 
what magic is needed to make an application link with
the vdso?  

You also mentioned that there are problems with newer
tool chains.  I think I'm seeing this problem when I
build on an FC6 system.  The vdso.so ends up using
file offsets like 00100120 so it doesn't fit in a 
single page.  This seems to be sensitive to the 
VDSO_PRELINK address.  If I changes this address to
0xffffffffff800000 then the vdso.so looks correct.
Is this change safe?  Is it enough to change the 
VDSO_PRELINK define or are there other values which 
need to be kept in sync?

Jim Houston - Concurrent Computer Corp.


