Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbYKYVBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbYKYVBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbYKYVAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:00:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35807 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbYKYVAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:00:51 -0500
Message-ID: <492C676A.6020901@zytor.com>
Date: Tue, 25 Nov 2008 13:00:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mark Jackson <mpfj@mimc.co.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: Help using initramfs
References: <492C6238.7060507@mimc.co.uk>
In-Reply-To: <492C6238.7060507@mimc.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Jackson wrote:
> I'm not sure if this is the correct place to be asking, but I've spend a
> while searching Google and am still no wiser.
> 
> I'm looking to use initramfs to create a simple bootable linux distro
> for our AVR32 based boards.
> 
> However, I have hit a brick wall at nearly the first step.
> 
> So far I've managed to create a "bloated" kernel containing the
> initramfs directory structure and I'm just trying to get a simple "Hello
> World" test app running.
> 
> The kernel boots, and the app runs, but I get no output on the console.
> 

Make sure /dev/null, /dev/zero, and *especially* /dev/console exists in
your initramfs.

	-hpa
