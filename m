Return-Path: <linux-kernel-owner+w=401wt.eu-S1751546AbXAXP4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbXAXP4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 10:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbXAXP4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 10:56:35 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:10321 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbXAXP4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 10:56:34 -0500
Date: Wed, 24 Jan 2007 07:51:45 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: Andrew Morton <akpm@osdl.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       adaplas@pol.net, linux-kernel@vger.kernel.org,
       Jordan Crouse <jordan.crouse@amd.com>
Subject: Re: [Linux-fbdev-devel] [PATCH] Recognize video=gx1fb:... option
Message-Id: <20070124075145.8481a9c3.randy.dunlap@oracle.com>
In-Reply-To: <20070124004826.0d1adffe.akpm@osdl.org>
References: <20070119211051.GC5013@martell.zuzino.mipt.ru>
	<20070124004826.0d1adffe.akpm@osdl.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jan 2007 00:48:26 -0800 Andrew Morton wrote:

> On Sat, 20 Jan 2007 00:10:51 +0300
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > Juergen Beisert reported that the following option doesn't work for him
> > 
> > 	video=gx1fb:1024x768-16@60
> > 
> > though sisfb was able to parse similar option correctly.
> > 
> 
> And does this patch fix it for him? ;)

Yes, Juergen replied to the patch:

Thank you very much. Yes it works. I tried these kernel parameters:

1) video=gx1fb:mode:1280x1024-16@60,crt:1
  -> CRT was active, 160x64 console
2) video=gx1fb:mode:1024x768-16@60,crt:1
  -> CRT was active, 128x48 console
3) video=gx1fb:mode:800x600-16@60,crt:0,panel:800x600
  -> CRT was disabled, 100x37 console
4) video=gx1fb:mode:1024x768-16@60,crt:0,panel:800x600
  -> CRT was disabled, 80x25 console

Sorry, I have no flatpanel, so I cannot test if the "panel" option works 
correctly. But somethings changes when I tried different values (see 3 and 
4).

Regards
Juergen


---
~Randy
