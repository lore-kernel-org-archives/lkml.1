Return-Path: <linux-kernel-owner+w=401wt.eu-S1760363AbYEXTXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363AbYEXTXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 15:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYEXTXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 15:23:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34082 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbYEXTXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 15:23:32 -0400
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
From: David Woodhouse <dwmw2@infradead.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Takashi Iwai <tiwai@suse.de>
In-Reply-To: <D56F641E-9FDB-48E5-AF0B-B8E84B08504A@holtmann.org>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <1211550374.28967.10.camel@pmac.infradead.org>
	 <20080523164108.GA31545@uranus.ravnborg.org>
	 <1211640377.540.14.camel@pmac.infradead.org>
	 <20080524152214.GA12582@uranus.ravnborg.org>
	 <1211642706.31212.85.camel@shinybook.infradead.org>
	 <1211643245.31212.88.camel@shinybook.infradead.org>
	 <D56F641E-9FDB-48E5-AF0B-B8E84B08504A@holtmann.org>
Content-Type: text/plain
Date: Sat, 24 May 2008 20:23:19 +0100
Message-Id: <1211656999.540.16.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-05-24 at 20:18 +0200, Marcel Holtmann wrote:
> Hi David,
> 
> >> Playing with it now. I fixed the mkdir thing by including $(objtree)
> >> in the target.
> >
> > Here's what I have (on top of the git tree) now. I just need to sort  
> > out
> > the clean/mrproper behaviour -- and possibly should rename the korg
> > firmware to firmware/korg/k1212.c_shipped?
> 
> so using "/" within the name parameter for request_firmware() is  
> actually forbidden. I know that some driver authers think it is a good  
> idea, but it is not.
> 
> I am actually working on a patch to make request_firmware() fail/warn  
> when the name has a "/" in it.
> 
> You don't need to consider any deep nesting of firmware file names. It  
> was never meant to be used like this.

Hm. Is there any fundamental reason why we should forbid this? It does
seem to make sense to let people use the namespace for it.

-- 
dwmw2

