Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbZKBFig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbZKBFig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 00:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbZKBFig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 00:38:36 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:47949 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbZKBFif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 00:38:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Olgz0Z15uloMjrTimtBIOOX7XCORQeSzt7y/DNmPzshOV/rJwBAf2vwTaPN3DKyDj7
         5kwbe7oaTD695dZMGuAHJkW2YLzHbooybSzc+GquyxjmFiJzIZSc8HP3uFWfeExnOwxa
         K04QhLAkQDdQjok00w3PQOA37ZS+hSQ2BX+zY=
Date: Sun, 1 Nov 2009 21:38:35 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: ALPS touchpad with 4 directions button doesnt work as intended
Message-ID: <20091102053834.GA3354@core.coreip.homeip.net>
References: <1256955018.9681.23.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256955018.9681.23.camel@maxim-laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxim,

On Sat, Oct 31, 2009 at 04:10:18AM +0200, Maxim Levitsky wrote:
> I have a acer 5720G laptop, and its touchpad (ALPS) has three buttons,
> usual left/right, and middle button that can be pressed in 4 directions.
> Up/down direction work fine, but left/right doesn't. This means that
> left direction  produces middle button click, and right direction
> doesn't work at all.
> I took a look at source, and I see that driver doesn't even know about
> such configuration.
> 
> Now I am sure its very easy to figure out what is send when no working
> button is pressed, but I am a bit confused what BTN_* event to assign to
> it, so it will work as horizontal scroll as intended.
> And unassign middle button from other direction....
> 

Synaptics driver maps multi-button to BTN_0...BTN_8 and it looks like
synaptics X driver maps teh 4-button case by default to
up/down/left/right scroll so I'd map ALPS the same.

-- 
Dmitry
