Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbZHIMaD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbZHIMaD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 08:30:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbZHIMaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 08:30:03 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:57934 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbZHIMaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 08:30:01 -0400
Date: Sun, 9 Aug 2009 14:28:18 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Karsten Keil <isdn@linux-pingi.de>
Cc: isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers/isdn/hisax: Correct use of
 request_region/request_mem_region
In-Reply-To: <200908091420.33935.isdn@linux-pingi.de>
Message-ID: <Pine.LNX.4.64.0908091427590.16252@ask.diku.dk>
References: <Pine.LNX.4.64.0908090942560.13271@ask.diku.dk>
 <Pine.LNX.4.64.0908091150310.13271@ask.diku.dk> <200908091420.33935.isdn@linux-pingi.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Aug 2009, Karsten Keil wrote:

> On Sonntag, 9. August 2009 11:51:14 you wrote:
> > Or perhaps it is the request_region that is incorrect, since the same
> > value is later used with ioremap?
> 
> Yes this is the real error, these cards have one IO port (hw.isurf.reset) and 
> one memory mapped IO area (
> hw.isurf.phymem).

OK, I will send a corrected patch shortly.

julia
