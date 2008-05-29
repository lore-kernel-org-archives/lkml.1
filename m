Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbYE2Lg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbYE2Lg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 07:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYE2Lgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 07:36:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39335 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751834AbYE2Lgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 07:36:42 -0400
Date: Thu, 29 May 2008 12:22:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Jens =?UTF-8?B?QsOkY2ttYW4=?= <jens.backman@gmail.com>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
Message-ID: <20080529122223.462bf396@core>
In-Reply-To: <483DE40D.8090608@tmr.com>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
	<95711f160805280934y77ed7d91tec5aeb531bf8013c@mail.gmail.com>
	<20080528195752.0cdcbc6d@core>
	<483DE40D.8090608@tmr.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I really don't think that's any part of the issue, the same memory and 
> bridge went 4-5x faster in other read cases. The truth is that the 
> raid-1 performance is really bad, and it's the code causing it AFAIK. If 
> you track the actual io it seems to read one drive at a time, in order, 
> without overlap.

Make sure the readahead is set to be a fair bit over the stripe size if
you are doing bulk data tests for a single file. (Or indeed in the real
world for that specific case ;))

