Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbXDPHcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbXDPHcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 03:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbXDPHcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 03:32:23 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:43285 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbXDPHcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 03:32:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hsvOHFOCaZXrrQVs0WXSgVRy1KTZWJIrBqZWj0J/CI17xH3KNTDLrGkvqRysBYZLS+vSa2LJ33UgCishCHRmTBOEHVtI08CTfUTT5A8CHeoBMzJNy6V5Ve9iTgbKRiZAT0h32SmKiOpEnvLmfzFa5C6wXs05/tPZEAouZUtHzDA=
Subject: Re: [2/2] 2.6.21-rc7: known regressions
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Dave Jones <davej@redhat.com>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Richard Purdie <rpurdie@rpsys.net>
In-Reply-To: <20070416072326.GA15281@redhat.com>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>
	 <20070416003723.GM3691@stusta.de> <20070416005446.GB21217@redhat.com>
	 <20070416011636.GO3691@stusta.de> <20070416062921.GB7528@redhat.com>
	 <1176706447.5129.6.camel@daplas>  <20070416072326.GA15281@redhat.com>
Content-Type: text/plain
Date: Mon, 16 Apr 2007 15:32:02 +0800
Message-Id: <1176708722.5129.8.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-16 at 03:23 -0400, Dave Jones wrote:
> On Mon, Apr 16, 2007 at 02:54:07PM +0800, Antonino A. Daplas wrote:
>  
>  > CONFIG_ACPI_VIDEO depends on BACKLIGHT_CLASS_DEVICE, which, in turn is
>  > enabled by FB_BACKLIGHT. So we can narrow it down further, can you try?
>  > 
>  > CONFIG_FB_BACKLIGHT=y
>  > CONFIG_ACPI_VIDEO=n
> 
> That also gets me a dead display. Backlight doesn't turn back on.

Anything under /sys/class/backlight?

Tony


