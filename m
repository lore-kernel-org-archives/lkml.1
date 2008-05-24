Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbYEXOqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbYEXOqc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 10:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbYEXOqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 10:46:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39135 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbYEXOqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 10:46:24 -0400
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Takashi Iwai <tiwai@suse.de>
In-Reply-To: <20080523164108.GA31545@uranus.ravnborg.org>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <1211550374.28967.10.camel@pmac.infradead.org>
	 <20080523164108.GA31545@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sat, 24 May 2008 15:46:17 +0100
Message-Id: <1211640377.540.14.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-23 at 18:41 +0200, Sam Ravnborg wrote:
> 
> Assignment to targets i smiisng so generated files are not cleaned
> by "make clean".
> 
> targets := $(FIRMWARE_OBJS)

It doesn't seem to have that effect. Whatever I do, on 'make clean'
the .o files are removed and the auto-generated .c files remain. Which
is probably OK.

-- 
dwmw2

