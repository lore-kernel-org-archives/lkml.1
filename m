Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbZF3Bj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbZF3Bj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 21:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZF3BjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 21:39:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46400 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbZF3BjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 21:39:19 -0400
Message-ID: <4A496A0C.809@kernel.org>
Date: Mon, 29 Jun 2009 18:27:40 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Marc Aurele La France <root@ualberta.ca>
CC: stable@kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@linux.intel.com>, Research.Support@ualberta.ca
Subject: Re: [PATCH] x86, setup (2.6.30-stable) fix 80x34 and 80x60 console
 modes
References: <alpine.BSO.1.10.0906291746410.14658@fanir.ucs.ualberta.ca>
In-Reply-To: <alpine.BSO.1.10.0906291746410.14658@fanir.ucs.ualberta.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Aurele La France wrote:
> As coded, most INT10 calls in video-vga.c allow the compiler to assume EAX 
> remains unchanged across them, which is not always the case.  This 
> triggers an optimisation issue that causes vga_set_vertical_end() to be 
> called with an incorrect number of scanlines.  Fix this by beefing up the 
> asm constraints on these calls.
> 
> Reported-by: Marc Aurele La France <tsi@xfree86.org>
> Signed-off-by: Marc Aurele La France <tsi@xfree86.org>
> Acked-by: H. Peter Anvin <hpa@zytor.com>

Note: this is not in upstream since upstream is not affected due to the
new "BIOS glovebox" subsystem.

	-hpa
