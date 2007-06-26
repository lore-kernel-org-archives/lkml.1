Return-Path: <linux-kernel-owner+w=401wt.eu-S1757531AbXFZOEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbXFZOEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 10:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbXFZOEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 10:04:06 -0400
Received: from canuck.infradead.org ([209.217.80.40]:39652 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbXFZOEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 10:04:05 -0400
Subject: Re: [PATCH] Fix headers_install for x86-64 (now with less
	whitespace damage!)
From: David Woodhouse <dwmw2@infradead.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200706260912.37441.rob@landley.net>
References: <200706260912.37441.rob@landley.net>
Content-Type: text/plain
Date: Tue, 26 Jun 2007 15:03:49 +0100
Message-Id: <1182866629.8896.37.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-26 at 09:12 -0400, Rob Landley wrote:
> Signed-off-by: Rob Landley <rob@landley.net>
>  
>  A bug in headers_install for ARCH=x86_64 yields an asm/ directory full of
>  files all of which are using the same #ifdef guard, "__ASM_STUB_" with no
>  postfix. So the second and later asm files #included in the same C file
>  (often through standard headers like ioctl.h) yields no symbols.

Interesting. It works here with bash 3.2 -- I thought it was the _first_
shell which expanded $FNAME and $STUBDEF inside the parentheses. Which
shell are you using?

Is it sufficient just to add the missing semicolon after FNAME=...?

-- 
dwmw2

