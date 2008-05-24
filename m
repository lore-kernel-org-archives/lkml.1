Return-Path: <linux-kernel-owner+w=401wt.eu-S1761313AbYEXSJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761313AbYEXSJf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 14:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759886AbYEXSJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 14:09:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49641 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759627AbYEXSJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 14:09:27 -0400
Message-ID: <483859BB.9030809@zytor.com>
Date: Sat, 24 May 2008 11:08:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Steve French <smfrench@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com> <48374D3F.1080502@zytor.com> <20080524054301.GA3773@uranus.ravnborg.org> <4837AAE2.9090102@zytor.com> <20080524064201.GA4133@uranus.ravnborg.org>
In-Reply-To: <20080524064201.GA4133@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>> I don't think we want to use "1 or 2"... I suspect we want to use the 
>> same booleans we currently have.
> I'm a bit dense (or I need more coffe - it's morning here).
> What "same booleans"?

Sorry, we already have CONFIG_FOO (meaning =y) and CONFIG_FOO_MODULE 
(meaning =m).  This seems to work well and will generally do the right 
thing.

If we had CFG_FOO=2 for the case of FOO=n then the clean use of:

	if (CFG_FOO && blah)...

... wouldn't work as nicely.

>> I would suggest CFG_* instead of CONFIG_* for the new set.
> Agreed.

	-hpa

