Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbYKYKnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbYKYKnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 05:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbYKYKnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 05:43:24 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60710 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752189AbYKYKnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 05:43:23 -0500
Date: Tue, 25 Nov 2008 10:43:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sheng Yang <sheng@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] 8250: Eliminate compile warning of 8250.c
Message-ID: <20081125104334.351e94ee@lxorguk.ukuu.org.uk>
In-Reply-To: <200811251831.34737.sheng@linux.intel.com>
References: <1227585320-3711-1-git-send-email-sheng@linux.intel.com>
	<1227585503-3833-1-git-send-email-sheng@linux.intel.com>
	<20081125102230.791fa168@lxorguk.ukuu.org.uk>
	<200811251831.34737.sheng@linux.intel.com>
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

> Can't understand initializing got "risk hiding future ones". As I know, didn't 

Because if you set it to NULL and later delete a line which does the
intended assignment you will no longer get a warning.

> think BUG_ON(n==null) cover this. And I don't think leave it to compiler is 
> more proper here.

The BUG_ON covers it, the current gcc gets this right and works it out.

NAK again

