Return-Path: <linux-kernel-owner+w=401wt.eu-S1765438AbXFEPpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765438AbXFEPpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762850AbXFEPpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:45:30 -0400
Received: from mx1.wp.pl ([212.77.101.5]:64724 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603AbXFEPp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:45:29 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jun 2007 11:45:29 EDT
Message-ID: <4666D559.7060906@wp.pl>
Date: Wed, 06 Jun 2007 17:40:09 +0200
From: Krzysztof Helt <krzysztof.h1@wp.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.7) Gecko/20060914 SeaMonkey/1.0.5
MIME-Version: 1.0
To: "Antonino A. Daplas" <adaplas@gmail.com>
CC: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] drivers/video/pm3fb.c: possible cleanups
References: <20070604221257.GD5500@stusta.de> <1181040354.5023.3.camel@daplas>
In-Reply-To: <1181040354.5023.3.camel@daplas>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000                                      
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Antonino A. Daplas wrote:
> 
> Krzysztof,
> 
> I think this patch is okay.  If you need to add an option parser
> for your driver, you can always add this in the future.
> 

I haven't been doing cleanup of this driver as I am still working on it (as time allows). The copyarea acceleration is done and working (it is faster than unaccelerated redraw even without the smart blitter patch).

I'll add the removed functions if they will be required. I have to check how many original (2.4) options overlap with generic options of the 2.6 kernel (like off or mode setting). Anyway, I am focused on acceleration at the moment.

Krzysztof
