Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbYKYLNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbYKYLNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 06:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYKYLNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 06:13:33 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46958 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752602AbYKYLNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:13:32 -0500
Date: Tue, 25 Nov 2008 11:13:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sheng Yang <sheng@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] 8250: Eliminate compile warning of 8250.c
Message-ID: <20081125111342.5383c957@lxorguk.ukuu.org.uk>
In-Reply-To: <200811251851.44768.sheng@linux.intel.com>
References: <1227585320-3711-1-git-send-email-sheng@linux.intel.com>
	<200811251831.34737.sheng@linux.intel.com>
	<20081125104334.351e94ee@lxorguk.ukuu.org.uk>
	<200811251851.44768.sheng@linux.intel.com>
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

> The logic here is strange...

Why

> If you used old compiler, you would get a warning, and you thought that's 
> ensured we won't delete a intended assignment by mistake.

No.. if you hid the warning by hacking around the compiler mistake with
extra bogus assignments you would hide a future mistake.
> 
> If you used new compiler, you wouldn't get a warning, and you think this time 
> the compiler get it right.

The compiler does now get it right - I checked.

Alan
