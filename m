Return-Path: <linux-kernel-owner+w=401wt.eu-S1764577AbYDOM7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764577AbYDOM7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 08:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757080AbYDOM6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 08:58:55 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:61095 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907AbYDOM6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 08:58:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=qjanYWCcSeTFx/93u+xHt1mSO5/6GZRp3Pld1JxeQ9nMtIKsmsUvbSmNaA6jFNi7/C8c2eS3WHXDWNzxZ2+QUFFEm9lAePlLkBnjpy1tYe10W/0Dg4kaM80h5vJAB5HALZ+4Hu10apTaU7kBAmSQorpsCTF0dF2ms42877Lzx+g=
Date: Tue, 15 Apr 2008 08:58:49 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 4/8] rfkill: add read-write rfkill switch support
Message-ID: <20080415085746.ZZRA012@mailhub.coreip.homeip.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804142006.51224.carlos@strangeworlds.co.uk> <20080414162209.ZZRA012@mailhub.coreip.homeip.net> <200804150827.49936.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804150827.49936.carlos@strangeworlds.co.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 08:27:49AM +0100, Carlos Corbacho wrote:
> On Monday 14 April 2008 21:23:14 Dmitry Torokhov wrote:
> > On Mon, Apr 14, 2008 at 08:06:50PM +0100, Carlos Corbacho wrote:
> > > I agree wholeheartedly with Henrique here though - wireless drivers
> > > should _not_ be using key press events as a reporting mechanism.
> >
> > Reporting mechanism for what exacly though? Depending on what you are
> > talking about we either agree or disagree here ;)
> 
> Reporting state change in this case. For instance, KEY_WLAN means exactly 
> that - a user pressed a key that was mapped to KEY_WLAN. It's not a generic 
> notifier for any and all wireless events, state changes, etc.
> 
> If wireless drivers want to report a state change, then we need a proper 
> mechanism for that, as has already been discussed by Henrique.
> 

I think everyone is in a violent agreement here but prefers to keep
talking to appear that they not agree ;)

-- 
Dmitry
