Return-Path: <linux-kernel-owner+w=401wt.eu-S1762782AbYBZQkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762782AbYBZQkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 11:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYBZQkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 11:40:25 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:15302 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbYBZQkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 11:40:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=j7QyJyhv0V7GmxIZntO7TdVIzH7RD/ChqAhum2cAsKR+4/P/Fz6n483JwM0eAVSrDOlX4SOrqRD6MPn9xIhxN+KaMAxPGoDriqk0UGE0QZl1f6KC2/Km2oY7z+wrwqXGdzOzaJHaX8fNJZMNxclk0u4Ijq7wEeVkiAHltMKj5NI=
Date: Tue, 26 Feb 2008 19:39:51 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: vmlinux.lds cleanup
Message-ID: <20080226163951.GA6748@cvg>
References: <20080225095800.GB6744@cvg> <20080225203307.GB23790@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225203307.GB23790@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sam Ravnborg - Mon, Feb 25, 2008 at 09:33:07PM +0100]
| On Mon, Feb 25, 2008 at 12:58:00PM +0300, Cyrill Gorcunov wrote:
| > Hi Sam,
| > 
| > you know I've just take a look on different architectures and I suddenly
| > realized that I even can't test my changes I'm bringnin in. For example -
| > xtensa arch, most of lds numeric constants could (and should) be changed
| > to PAGE_SIZE and THREAD_SIZE but this requires to include additional
| > heades in lds script and I'm not even sure if it link without errors...
| > (actually, i'm absolutely sure there would be errors ;)
| > 
| > I'm not sure, but maybe it would be more convenient to ask mainteiners
| > fix their scripts? At least their have access to an appropriate hardware
| > to test.
| 
| I have in most cases the relevant toolchains and then I manually inspect
| the generated .lds file.
| In other cases I just do my best to make it correct and tell in my
| submisison that htis is not build tested. (This type of
| info belongs below the three dasches '---').
| 
| 	Sam
| 

got it, thanks ;)

		- Cyrill -
