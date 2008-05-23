Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbYEWRWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbYEWRWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYEWRVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:21:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53266 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbYEWRVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:21:54 -0400
Subject: Re: [PATCH 1/3] firmware: allow firmware files to be built into
	kernel	image
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       aoliva@redhat.com, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Haroldo Gamal <gamal@alternex.com.br>
In-Reply-To: <20080523163303.492c89e4@core>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <s5hbq2xul4s.wl%tiwai@suse.de>
	 <1211554711.28967.25.camel@pmac.infradead.org>
	 <20080523163303.492c89e4@core>
Content-Type: text/plain
Date: Fri, 23 May 2008 18:21:48 +0100
Message-Id: <1211563308.28967.55.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-23 at 16:33 +0100, Alan Cox wrote:
> > Yeah, I thought about that. I was slightly concerned that drivers might
> > actually try to _modify_ the firmware they loaded, though. As it is,
> > there's no fundamental reason why they shouldn't do that.
> 
> I've not seen any that do and judicious use of "const" should catch
> offenders.

Makes sense. I'll do that as the first patch of the sequence.

-- 
dwmw2

