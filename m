Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab0AOIyM (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 03:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445Ab0AOIyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 03:54:11 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:59898 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab0AOIyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 03:54:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Z/8tfzYyCzPhoobUnmnRW/3RNtGyati6VdWSpi7CrmOfChE+NM/FoIc3EUxwkIq/+l
         fh7PGpSRjgl3hAs+dUX/rZ+2i6w/Zo5MIrxUbjnlEbCDsJoxmxURA1lNs1WhRonrBaoJ
         yZVYBo6iojwo+XD5HGuaf1llA5pJ+6wuNlEps=
MIME-Version: 1.0
In-Reply-To: <hiofke$dp5$1@ger.gmane.org>
References: <alpine.LFD.2.00.1001122139411.17145@localhost.localdomain>
	 <20100113133357.67f9df6d@jbarnes-piketon>
	 <4B4E403C.1050509@cs.helsinki.fi>
	 <20100113165530.2a7e7645@jbarnes-piketon>
	 <4B4F6D5F.10008@cs.helsinki.fi>
	 <20100114193118.GA1203@emergent.ellipticsemi.com>
	 <84144f021001141218pa3cd71co76165532618145a8@mail.gmail.com>
	 <20100114202803.GA1749@emergent.ellipticsemi.com>
	 <20100114124802.025bbcae@jbarnes-piketon> <hiofke$dp5$1@ger.gmane.org>
Date: Fri, 15 Jan 2010 10:54:05 +0200
X-Google-Sender-Auth: a36b2d9f62119a3a
Message-ID: <84144f021001150054m532cd1cdwbbdbab79b5924fb7@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: disable LVDS downclock by default
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Bowler <nbowler@draconx.ca>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(Fixing CC.)

On Fri, Jan 15, 2010 at 3:15 AM, Nick Bowler <nbowler@draconx.ca> wrote:
> On Thu, 14 Jan 2010 12:48:02 -0800, Jesse Barnes wrote:
>> Nick and Pekka, please try this out and reply with your Tested-by
>> (assuming it works, if not I'll fix it up).
>
> Not surprisingly, your patch solves the issues on my T500, and allows me
> to re-enable the broken behaviour by adding the i915.lvds_downclock=1
> boot option.
>
> Tested-by: Nick Bowler <nbowler@elliptictech.com>

So, any suggestions how I should proceed with figuring out the
"flashing" problem I still see with Jesse's patch? I can do a full git
bisect if it comes to that but it's going to be bit difficult to
determine if a commit is good or bad as there seem to be _two_
different problems both of which cause screen flickering.

Heelp!

                        Pekka
