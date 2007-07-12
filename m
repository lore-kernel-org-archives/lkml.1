Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbXGLIMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbXGLIMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 04:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757805AbXGLIMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 04:12:13 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:42970 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757914AbXGLIMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 04:12:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=m9Sd1nmnAp6pab+FqDni0fUz54SiyUT7GfJ98uIaU65s3h1lm2lF83Sdxhpx3w5fG+qBzpH1LdLnoxdb3yX5B6pAVtMJcJEpWBjE0ec4jsXdlgP6/LjsI1P8CG4e+IUMlzMWTgXDk191TYkNugl1SVJBxDelaBJ+sfb12SdM9ls=
Subject: Re: [Linux-fbdev-devel] [PATCH 0/4] fbdev: uvesafb
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: spock@gentoo.org, linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070623104920.GA12623@spock.one.pl>
References: <20070623104920.GA12623@spock.one.pl>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 16:12:01 +0800
Message-Id: <1184227922.4504.22.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-23 at 12:49 +0200, Michal Januszewski wrote:

My apologies for the delayed response. I had problems with my ISP.
 
> uvesafb is a generic driver for VBE2+ compliant video cards; an enhanced
> version of vesafb and a direct successor of vesafb-tng [1].
> 
> uvesafb uses a userspace helper application (v86d, [2]) to run the x86
> Video BIOS code.  This makes it possible to include in uvesafb all the
> standard features (refresh rate control, video mode changes etc) that
> are missing from vesafb without resorting to ugly hacks such as the ones
> used in [1].  The current implementation of v86d can use either LRMI or
> x86emu to run the BIOS code and supports both x86 and x86_64.
> 
> [1] http://dev.gentoo.org/~spock/projects/vesafb-tng/
> [2] http://dev.gentoo.org/~spock/projects/uvesafb/
> 

This is cool, I had a similar project before (which did work) but
abandoned it. In fact, it need not be restricted to vbe, as long as the
userspace daemon can interpret VESA.

Tony


