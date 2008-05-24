Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbYEXOmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbYEXOmE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 10:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757136AbYEXOlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 10:41:52 -0400
Received: from gw.goop.org ([64.81.55.164]:43426 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757142AbYEXOlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 10:41:51 -0400
Message-ID: <48382911.8090807@goop.org>
Date: Sat, 24 May 2008 15:41:21 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Sam Ravnborg <sam@ravnborg.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Steve French <smfrench@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com> <48374D3F.1080502@zytor.com> <20080524054301.GA3773@uranus.ravnborg.org> <4837AAE2.9090102@zytor.com> <20080524064201.GA4133@uranus.ravnborg.org> <4837E89D.9040008@goop.org> <20080524112704.GA7292@uranus.ravnborg.org> <483827CE.9080200@goop.org> <20080524143950.GG6749@1wt.eu>
In-Reply-To: <20080524143950.GG6749@1wt.eu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> You still have the possibility to use the "-0" trick :
>
>  	if (CFG_THINGY_LIMIT && x > (CONFIG_THINGY_LIMIT-0)) {...}
>   

Oh, that's cute in a vile way.  I hadn't seen it before.

    J

