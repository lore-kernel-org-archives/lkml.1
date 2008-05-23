Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbYEWO7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbYEWO7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 10:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYEWO7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 10:59:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40436 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbYEWO7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 10:59:40 -0400
Subject: Re: [PATCH 2/3] firmware: convert korg1212 driver to use
	firmware	loader exclusively
From: David Woodhouse <dwmw2@infradead.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Haroldo Gamal <gamal@alternex.com.br>
In-Reply-To: <s5habihukzy.wl%tiwai@suse.de>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <1211550374.28967.10.camel@pmac.infradead.org>
	 <1211550654.28967.16.camel@pmac.infradead.org>
	 <s5habihukzy.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Fri, 23 May 2008 15:59:37 +0100
Message-Id: <1211554777.28967.27.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-23 at 16:56 +0200, Takashi Iwai wrote:
> 
> There are a few more sound drivers doing similar things:
> isa/snd-sb16-csp, isa/snd-wavefront, pci/snd-maestro3, and
> pci/snd-ymfpci.
>
> I guess you already know but just to be sure...
 
Yeah, thanks -- and then there are the drivers which don't even have the
_option_ of using the firmware loader yet. I just did one, as a proof of
concept...


-- 
dwmw2

