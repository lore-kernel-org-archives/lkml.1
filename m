Return-Path: <linux-kernel-owner+w=401wt.eu-S933452AbZLPHDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452AbZLPHDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 02:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbZLPHDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 02:03:49 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:51296 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbZLPHDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 02:03:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MSCUSeTXssJ66FIz0vKqhac9KXONJQ6EpCj2u4LiJDL40aWQNp26GCQ975IdTLBRPj
         qci3Vcrq7uAwY9m6xfFFVVyu+mQUrgD5Sh2pCPf+Clx14jtr5Qfk+QVCgwT6nSNvU9CV
         +Tf6DfpnS8vGdQuVZdYXlh68jJ/3NlNgfyhh8=
Date: Tue, 15 Dec 2009 23:03:43 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alex Chiang <achiang@hp.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: synaptics touchpad doesn't click
Message-ID: <20091216070343.GF2699@core.coreip.homeip.net>
References: <20091214173450.GB2373@core.coreip.homeip.net> <20091215034127.GC587@ldl.fc.hp.com> <20091215062628.GA12669@core.coreip.homeip.net> <s5h1viwn3ig.wl%tiwai@suse.de> <20091215073358.GC12669@core.coreip.homeip.net> <s5hvdg8lm5q.wl%tiwai@suse.de> <20091215082518.GD12669@core.coreip.homeip.net> <20091216010506.GA26367@ldl.fc.hp.com> <20091216025934.GA2699@core.coreip.homeip.net> <20091216065200.GC20352@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216065200.GC20352@ldl.fc.hp.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 11:52:00PM -0700, Alex Chiang wrote:
> * Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> > On Tue, Dec 15, 2009 at 06:05:06PM -0700, Alex Chiang wrote:
> > > * Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> > > >
> > > > The updated patch is below.
> > > > 
> > > > -- 
> > > > Dmitry
> > > 
> > > Should I test this one or wait one more iteration to address
> > > Takashi's last comments?
> > > 
> > 
> > Actually I think we took the wrong direction with the original patch and
> > we should do what other buttonless devices (bcm5974) do: report touchpad
> > click as left button and have Synaptics X driver provide enhanced
> > support. This way we can have both modes (ClickZones and ClickButtons)
> > and users will get to chose (provided that someone takes time to add
> > that support to Synaptics driver of course ;) ).
> > 
> > Could you tell me if the below works for you?
> 
> Left clicks work. Right/middle do not (as expected, I guess).
> 
> I liked the behaviour of Takashi's patch a little better wrt what
> happens when you try to click/drag, because he disabled movement
> in the click area.

Are the clicks register only in that special area? Reading Synaptics
product description it sounds like entire surface should be clickable.

> My vodka consumption is minimal and I don't have the shakes, but
> I found it difficult to precisely hit the edge of a window and
> click / drag to resize...
> 

-- 
Dmitry
