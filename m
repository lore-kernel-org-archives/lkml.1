Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299AbYHSPhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbYHSPhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 11:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbYHSPhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 11:37:19 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:43780 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbYHSPhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 11:37:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vS0D1WWXpMbPqO6qPbB7hAR3ZE3zctOK/J5UwhvoLt6Nw2C+IsKjXjl4cq9RN3LNqw
         mTw20/SYRzXGIZzrvSi0hUFUtiYxWFm8McIjI6uA9NUUHzioM+znndxzgno/acnDQ22i
         cuT/2cONwslUwAkpnYqOBY3VUNBlt4gIP6rvQ=
Date: Tue, 19 Aug 2008 11:37:13 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/input/evdev.c: Fix printf() format for sizeof
Message-ID: <20080819113632.ZZRA012@mailhub.coreip.homeip.net>
References: <Pine.LNX.4.64.0808191137160.1565@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808191137160.1565@vixen.sonytel.be>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 11:43:32AM +0200, Geert Uytterhoeven wrote:
> commit f2afa7711f8585ffc088ba538b9a510e0d5dca12 ("Input: paper over a bug in
> Synaptics X driver") introduced a compiler warning on 64-bit platforms, as
> sizeof() returns a size_t, not an (unsigned) int:
> 
> | drivers/input/evdev.c: In function 'handle_eviocgbit':
> | drivers/input/evdev.c:684: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
> 
> Use the proper `z' modifier for size_t, and make the printf() formats for the
> sizes unsigned while we're at it.
> 

Oops... Applied, thank you Geert.

-- 
Dmitry
