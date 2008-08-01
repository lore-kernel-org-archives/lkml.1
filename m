Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbYHASf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbYHASf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759376AbYHASe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:34:58 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:25002 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759370AbYHASe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:34:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=a12HrHPV9iumc+mpkQ02Zd6NyqbOhpd89WGdyvbnbaFh/dHkl1ZBg2SeB6huACEii0
         SCImYYpVFC6khVs+3VaXnJ4EBTdRyU5OOgICN7wAEDnjYSDO1m6GDs4tExrayPjala9/
         4jjJlbQQY2x5r7eITvcA7AmctcADSh+644UNU=
Date: Fri, 1 Aug 2008 14:34:51 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OLPC: psmouse: touchpad driver
Message-ID: <20080801143150.ZZRA012@mailhub.coreip.homeip.net>
References: <20080801142004.2d3d1349@fred>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801142004.2d3d1349@fred>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 02:20:04PM -0400, Andres Salomon wrote:
> 
> This adds support for OLPC's touchpad.  It has lots of neat features,
> none of which are enabled because the hardware is too buggy.  Instead,
> we use it like a normal touchpad, but with a number of workarounds in
> place to deal with the frequent hardware spasms.  Humidity changes,
> sweat, tinfoil underwear, plugging in AC, drinks, evil felines.. All
> tend to cause the touchpad to freak out.
> 
> Stuff like this keeps me from getting bored.
> 

Good stuff, thank you. I bet you named the module olpc and gave pregix
hgpk to all the functions to mess with mt feeble brain ;) Maybe we
should rename the module to hgpk as well?

> From psmouse-base, we use psmouse_set_state quite a bit, as well
> as piggy-backing off of kpsmoused_wq; so, this also makes those
> available to protocol extensions.
>

Do you think we should provide assessor functions to deal with
kpsmoused instead of playing with it directly? I was thinking about
starting it on-demand for protocols that may use it and shut it off by
default.

-- 
Dmitry
