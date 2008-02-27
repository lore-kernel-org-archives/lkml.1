Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbYB0S56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbYB0S56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 13:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757593AbYB0S5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 13:57:47 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:34703 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757587AbYB0S5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 13:57:46 -0500
Date: Wed, 27 Feb 2008 19:57:56 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] alpha: vmlinux.lds cleanup - use THREAD_SIZE macro
Message-ID: <20080227185756.GA12569@uranus.ravnborg.org>
References: <20080226195159.GC6748@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226195159.GC6748@cvg>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 10:51:59PM +0300, Cyrill Gorcunov wrote:
> This patch modifies thread_info.h header to be able to include it
> into linker script and then we're able to use THREAD_SIZE in
> vmlinux.lds
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>

And I also build tested the patch and checked the
resulting .lds files.
And they were semantically equal.

	Sam
