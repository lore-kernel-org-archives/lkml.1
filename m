Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbZKBRU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbZKBRU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbZKBRU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:20:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:23987 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbZKBRU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:20:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tUoCoGtb6hC4N4w7gxHMY57E/OjlOPAC11M6mPToBTmVikm0t4xoKibyzQCpK9CfMm
         k6pJquzJuIfeboxdVGf8Qy9AeQiv1x1a93iDa/7JznTVeaAAfx15djXhgmt/GqgvBErH
         EMnM/eXCAp5S74z/P7kiEau5rfth1YLhiQ/tM=
Subject: Re: ALPS touchpad with 4 directions button doesnt work as intended
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>
In-Reply-To: <20091102053834.GA3354@core.coreip.homeip.net>
References: <1256955018.9681.23.camel@maxim-laptop>
	 <20091102053834.GA3354@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Nov 2009 19:20:26 +0200
Message-ID: <1257182426.3682.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-01 at 21:38 -0800, Dmitry Torokhov wrote: 
> Hi Maxim,
> 
> On Sat, Oct 31, 2009 at 04:10:18AM +0200, Maxim Levitsky wrote:
> > I have a acer 5720G laptop, and its touchpad (ALPS) has three buttons,
> > usual left/right, and middle button that can be pressed in 4 directions.
> > Up/down direction work fine, but left/right doesn't. This means that
> > left direction  produces middle button click, and right direction
> > doesn't work at all.
> > I took a look at source, and I see that driver doesn't even know about
> > such configuration.
> > 
> > Now I am sure its very easy to figure out what is send when no working
> > button is pressed, but I am a bit confused what BTN_* event to assign to
> > it, so it will work as horizontal scroll as intended.
> > And unassign middle button from other direction....
> > 
> 
> Synaptics driver maps multi-button to BTN_0...BTN_8 and it looks like
> synaptics X driver maps teh 4-button case by default to
> up/down/left/right scroll so I'd map ALPS the same.
> 
Thanks!

One question, should I expect some resistance because the button won't
work as middle button by default? (I am sure that in X its easy remap it
back)

Best regards,
Maxim Levitsky

