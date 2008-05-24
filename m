Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbYEXSSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbYEXSSp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 14:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760063AbYEXSSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 14:18:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47666 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759663AbYEXSSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 14:18:37 -0400
Message-ID: <48385A76.9020907@zytor.com>
Date: Sat, 24 May 2008 11:12:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Sam Ravnborg <sam@ravnborg.org>,
       Steve French <smfrench@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com>	 <48374D3F.1080502@zytor.com>	 <20080524054301.GA3773@uranus.ravnborg.org>	 <4837AAE2.9090102@zytor.com>	 <20080524064201.GA4133@uranus.ravnborg.org>	 <4837E89D.9040008@goop.org>	 <20080524112704.GA7292@uranus.ravnborg.org>	 <483827CE.9080200@goop.org>	 <20080524153611.GA13890@uranus.ravnborg.org>	 <48383830.6060504@goop.org> <19f34abd0805240857l57e667fdicb240baf898f6296@mail.gmail.com>
In-Reply-To: <19f34abd0805240857l57e667fdicb240baf898f6296@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> 
> Why not use all-lowercase config_* names? It seems elegant, and fits
> in with the notion that these are to be used not as macros, but as
> ordinary constants.
> 
> (The only disadvantage I can see is that they will stand out less. But
> I don't know how great the disadvantage is.)
> 

I think that would be a massive disadvantage.  Furthermore, they *can* 
(and arguably *should*) still be used for the preprocessor; something like:

#if CFG_BLUTTAN

... at least can be configured to warn on a typo.

	-hpa

