Return-Path: <linux-kernel-owner+w=401wt.eu-S965427AbXDBNgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965427AbXDBNgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 09:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965430AbXDBNgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 09:36:41 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:50835 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965427AbXDBNgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 09:36:40 -0400
Date: Mon, 2 Apr 2007 15:34:06 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Antonino A. Daplas" <adaplas@gmail.com>
cc: Paul LeoNerd Evans <leonerd@leonerd.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Daniel Jacobowitz <dan@debian.org>
Subject: Re: [PATCH 17/16] Do not reset UTF8 on terminal reset
In-Reply-To: <1175518079.4545.3.camel@daplas>
Message-ID: <Pine.LNX.4.61.0704021532220.29350@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr> 
 <Pine.LNX.4.61.0704012001130.12316@yvahk01.tjqt.qr>  <1175496595.4614.11.camel@daplas>
  <Pine.LNX.4.61.0704020904460.1245@yvahk01.tjqt.qr>  <20070402112607.GK26707@cel.leo>
 <1175514253.4431.7.camel@daplas>  <20070402115411.GL26707@cel.leo>
 <1175518079.4545.3.camel@daplas>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 2 2007 20:47, Antonino A. Daplas wrote:
>> 
>> It would be nice if the kernel's default UTF-8 mode for new VCs could be
>> synched to whatever local policy was regarding locale.
>
>How about this? This should allow us to reset the terminal without
>affecting utf, and also allows setting of a global utf default that can
>be set via boot option or sysfs:
>
>echo 1 > /sys/module/vt/parameters/default_utf

Might want to call it "default_utf8", but it's just minor.

Tony, if you have a patch, send it along so I can test it under "special local
circumstances" :-)

Jan
-- 
