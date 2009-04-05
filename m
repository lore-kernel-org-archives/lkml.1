Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbZDEB55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbZDEB55 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 21:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbZDEB5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 21:57:48 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:49108 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbZDEB5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 21:57:47 -0400
Message-ID: <49D8100F.1060504@davidnewall.com>
Date: Sun, 05 Apr 2009 11:27:35 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeff Garzik <jeff@garzik.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Mark Lord <lkml@rtr.ca>, torvalds@linux-foundation.org, tytso@mit.edu,
       drees76@gmail.com, jesper@krogh.cc, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>	<20090326171148.9bf8f1ec.akpm@linux-foundation.org>	<alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>	<20090326174704.cd36bf7b.akpm@linux-foundation.org>	<alpine.LFD.2.00.0903261752110.3994@localhost.localdomain>	<20090326182519.d576d703.akpm@linux-foundation.org>	<20090401210337.GB3797@csclub.uwaterloo.ca>	<20090401143622.b1885643.akpm@linux-foundation.org>	<20090401225737.GC3797@csclub.uwaterloo.ca>	<49D6214A.9030204@rtr.ca>	<20090403151648.GJ3795@csclub.uwaterloo.ca>	<49D65C80.4080003@garzik.org> <20090404011838.9c39a78a.akpm@linux-foundation.org>
In-Reply-To: <20090404011838.9c39a78a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> - open the file
>
> - unlink the file
>
> - now sit in a loop, slowly nibbling away at the tail with
>   ftruncate() until the file is gone.

Why not fork and unlink in the child?
