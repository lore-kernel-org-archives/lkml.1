Return-Path: <linux-kernel-owner+w=401wt.eu-S966065AbXDCA1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966065AbXDCA1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 20:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966124AbXDCA1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 20:27:16 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:34728 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966065AbXDCA1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 20:27:16 -0400
Date: Tue, 3 Apr 2007 02:23:40 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Antonino A. Daplas" <adaplas@gmail.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Paul LeoNerd Evans <leonerd@leonerd.org.uk>
Subject: Re: [PATCH] vt: Do not clear UTF when resetting console
In-Reply-To: <1175559377.7267.13.camel@daplas>
Message-ID: <Pine.LNX.4.61.0704030220140.18387@yvahk01.tjqt.qr>
References: <46110F88.5040905@gmail.com>  <46113ED6.4060005@zytor.com>
 <1175559377.7267.13.camel@daplas>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 3 2007 08:16, Antonino A. Daplas wrote:
>
>That would be the cleanest and purest behavior. But it's possible to set
>one console to UTF-8 and another to legacy mode.

The question would be: why would you want to have mixed consoles?
Switching to UTF8 IMO does not take away any characters, and I mean
no-framebuffer 80x25 that is limited to 256 glyphs.


Jan
-- 
