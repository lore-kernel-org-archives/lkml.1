Return-Path: <linux-kernel-owner+w=401wt.eu-S1756417AbYEWO6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417AbYEWO6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 10:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYEWO6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 10:58:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40383 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbYEWO6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 10:58:35 -0400
Subject: Re: [PATCH 1/3] firmware: allow firmware files to be built into
	kernel	image
From: David Woodhouse <dwmw2@infradead.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Haroldo Gamal <gamal@alternex.com.br>
In-Reply-To: <s5hbq2xul4s.wl%tiwai@suse.de>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <s5hbq2xul4s.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Fri, 23 May 2008 15:58:31 +0100
Message-Id: <1211554711.28967.25.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-23 at 16:53 +0200, Takashi Iwai wrote:
> This looks like a nice cleanup.  It'd be nicer if we can skip vmalloc
> and duplication of the image for static binaries.

Yeah, I thought about that. I was slightly concerned that drivers might
actually try to _modify_ the firmware they loaded, though. As it is,
there's no fundamental reason why they shouldn't do that.

If we're willing to declare that drivers mustn't write to the firmware
data, then we could do as you suggest.

> BTW, is the dependency considered?  FW_LOADER depends on HOTPLUG, and
> the static loader shouldn't depend on HOTPLUG.

Ah, good point; I'll take a closer look at that. Thanks.

-- 
dwmw2

