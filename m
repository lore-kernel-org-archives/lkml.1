Return-Path: <linux-kernel-owner+w=401wt.eu-S965007AbXHaLcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965007AbXHaLcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 07:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbXHaLcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 07:32:18 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:39645 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033AbXHaLcS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 07:32:18 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: possible build system oddity
Date: Fri, 31 Aug 2007 13:32:19 +0200
User-Agent: KMail/1.9.6 (enterprise 20070731.694771)
References: <200708311037.29280.oliver@neukum.org> <20070831084229.GE9260@stusta.de>
In-Reply-To: <20070831084229.GE9260@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708311332.20285.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 31 August 2007 schrieben Sie:
> On Fri, Aug 31, 2007 at 10:37:28AM +0200, Oliver Neukum wrote:
> > Hi,
> > 
> > I only touched sound/usb/usbaudio.c
> > Nevertheless the whole subtree und sound/ is recompiling. What's
> > happening?
> 
> The only file that gets compiled (CC) should be sound/usb/usbaudio.c
> 
> It seems you are confused by the fact that this recompilation results in 
> several relinks (LD)?
> 
> >       Regards
> >               Oliver
> 
> cu
> Adrian

Nope, it recompiled everything under sound/ and a lot of stuff under
net/. I'll check the system for odd scripts running at night touching stuff.

	Regards
		Oliver

