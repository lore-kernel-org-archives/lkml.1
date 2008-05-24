Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbYEXPWC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbYEXPWC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 11:22:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbYEXPVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 11:21:53 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:44311 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbYEXPVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 11:21:52 -0400
Date: Sat, 24 May 2008 17:22:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Message-ID: <20080524152214.GA12582@uranus.ravnborg.org>
References: <1211550282.28967.8.camel@pmac.infradead.org> <1211550374.28967.10.camel@pmac.infradead.org> <20080523164108.GA31545@uranus.ravnborg.org> <1211640377.540.14.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211640377.540.14.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 03:46:17PM +0100, David Woodhouse wrote:
> On Fri, 2008-05-23 at 18:41 +0200, Sam Ravnborg wrote:
> > 
> > Assignment to targets i smiisng so generated files are not cleaned
> > by "make clean".
> > 
> > targets := $(FIRMWARE_OBJS)
> 
> It doesn't seem to have that effect. Whatever I do, on 'make clean'
> the .o files are removed and the auto-generated .c files remain. Which
> is probably OK.

strange - like 'make clean' does not vist this directory??

The .o files are deleted using a simple find ...
which explain why they are hit.
I have not applied your patches but if you d not see issues
with it I wil not try to chase it further atm.

	Sam
