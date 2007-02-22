Return-Path: <linux-kernel-owner+w=401wt.eu-S1751717AbXBVRAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbXBVRAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 12:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbXBVRAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 12:00:48 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:27222 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbXBVRAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 12:00:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hdZT8vy6nMJ+qUnjfCEDemYYLI3jmBY3XsQYt1mebnaOa9ikzauQ83EeK0qMO23L7WMXJ9kZLJkuJR5U16Iw2ezcsLp8RKsiwHafmV7Ce31Cp6yWSkRtUeMfi6KbwdUNmlhUPYnXpEtdEtIMj7/1aFqZRVt03S+GkaYe0B1ghno=
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: James Simmons <jsimmons@infradead.org>, Luca Tettamanti <kronos@people.it>,
       linux-fbdev-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <cb7bb73a0702220755y3eb2e5b1r8e7908ae0c1720c9@mail.gmail.com>
References: <ephv35$4i3$1@sea.gmane.org>
	 <20070130203301.GA15067@dreamland.darkstar.lan>
	 <20070204201713.GA12867@dreamland.darkstar.lan>
	 <Pine.LNX.4.64.0702062034380.9224@pentafluge.infradead.org>
	 <cb7bb73a0702061508x767882dcia1b13f85d898b6e7@mail.gmail.com>
	 <1172101406.4217.16.camel@daplas>
	 <cb7bb73a0702220001u6acbdd95ncdc9fad10d06b421@mail.gmail.com>
	 <1172133646.4086.5.camel@daplas>
	 <cb7bb73a0702220548s55380f7fk995726ffd349823b@mail.gmail.com>
	 <1172153358.4306.17.camel@daplas>
	 <cb7bb73a0702220755y3eb2e5b1r8e7908ae0c1720c9@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 23 Feb 2007 01:03:31 +0800
Message-Id: <1172163811.4198.19.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 16:55 +0100, Giuseppe Bilotta wrote:
> On 2/22/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> However, I'm still getting the same snowy effects, which doesn't come
> as a surprise since the actual mode timings used are just the same ...
> 

BTW, you can also use CVT modes for nvidiafb, even if the mode in
question is not present in the EDID block.  For example:

video=nvidiafb:1024x768M@60 or 1600x1200M@60 

(The 'M' tells fb_find_mode to do a CVT calculation instead).

If you use a reduced-blanking CVT mode, it might even reduce the snow of
your DVI even at the highest resolution.  So:

video=nvidiafb:1600x1200MR@60

(The additional 'R' will do reduced-blanking CVT calculation)

Tony

