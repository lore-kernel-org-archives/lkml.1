Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbYEXPZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbYEXPZK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 11:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYEXPY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 11:24:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33150 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbYEXPY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 11:24:59 -0400
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Takashi Iwai <tiwai@suse.de>
In-Reply-To: <20080524152214.GA12582@uranus.ravnborg.org>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <1211550374.28967.10.camel@pmac.infradead.org>
	 <20080523164108.GA31545@uranus.ravnborg.org>
	 <1211640377.540.14.camel@pmac.infradead.org>
	 <20080524152214.GA12582@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sat, 24 May 2008 16:25:06 +0100
Message-Id: <1211642706.31212.85.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-05-24 at 17:22 +0200, Sam Ravnborg wrote:
> 
> strange - like 'make clean' does not vist this directory??
> 
> The .o files are deleted using a simple find ...
> which explain why they are hit.
> I have not applied your patches but if you d not see issues
> with it I wil not try to chase it further atm.

Playing with it now. I fixed the mkdir thing by including $(objtree) in
the target.

-- 
dwmw2

