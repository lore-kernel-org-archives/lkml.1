Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbZKJVdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbZKJVdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001AbZKJVdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:33:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60347 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbZKJVdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:33:35 -0500
Message-ID: <4AF9DA6B.803@zytor.com>
Date: Tue, 10 Nov 2009 13:26:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Matt Thrailkill <matt.thrailkill@gmail.com>
CC: Pavel Machek <pavel@ucw.cz>, Willy Tarreau <w@1wt.eu>,
       Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <20091110052711.GA15338@1wt.eu> <4AF9435F.2070103@redhat.com> 	<20091110105642.215804e0@lxorguk.ukuu.org.uk> <4AF99E04.8080704@zytor.com> 	<20091110172454.3c4481f2@lxorguk.ukuu.org.uk> <4AF9B5AB.5010800@zytor.com> 	<4AF9C3EF.6000705@redhat.com> <4AF9C6AB.8080006@zytor.com> 	<20091110201602.GA26633@1wt.eu> <20091110205445.GB1407@ucw.cz> <a91053ef0911101321he1cf15cx8d15d747b371fde4@mail.gmail.com>
In-Reply-To: <a91053ef0911101321he1cf15cx8d15d747b371fde4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 01:21 PM, Matt Thrailkill wrote:
> On Tue, Nov 10, 2009 at 12:54 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> *One* CMOV in the inner loop will make your performance go down 20x.
> 
> This is 20x slower than not running at all, right?

And that's the fundamental win of doing a fullscale emulator: you will
always be able to run, at *some* performance level.

	-hpa

