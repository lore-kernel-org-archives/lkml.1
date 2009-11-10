Return-Path: <linux-kernel-owner+w=401wt.eu-S1758618AbZKJWhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbZKJWhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758531AbZKJWhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:37:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41299 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758440AbZKJWg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:36:57 -0500
Message-ID: <4AF9E94D.5040601@zytor.com>
Date: Tue, 10 Nov 2009 14:29:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Willy Tarreau <w@1wt.eu>, Pavel Machek <pavel@ucw.cz>,
       Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <20091110105642.215804e0@lxorguk.ukuu.org.uk> <4AF99E04.8080704@zytor.com> <20091110172454.3c4481f2@lxorguk.ukuu.org.uk> <4AF9B5AB.5010800@zytor.com> <4AF9C3EF.6000705@redhat.com> <4AF9C6AB.8080006@zytor.com> <20091110201602.GA26633@1wt.eu> <20091110205445.GB1407@ucw.cz> <20091110211259.GD26633@1wt.eu> <4AF9D8E2.7050205@zytor.com> <20091110222756.GF15159@caffeine.csclub.uwaterloo.ca>
In-Reply-To: <20091110222756.GF15159@caffeine.csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 02:27 PM, Lennart Sorensen wrote:
> On Tue, Nov 10, 2009 at 01:19:30PM -0800, H. Peter Anvin wrote:
>> Willy, perhaps you can come up with a list of features you think should
>> be emulated, together with an explanation of why you opted for that list
>> of features and *did not* opt for others.
>>
>> Note: emulated FPU is a special subcase.  The FPU operations are
>> heavyweight enough that the overhead of trapping versus library calls is
>> relatively insignificant.
> 
> That doesn't seem to be the experience of the arm EABI versus the old
> arm ABI with kernel FPU emulation.  Using user space library calls for
> FPU is vastly faster than the trapping and kernel FPU emulation.

I don't believe we were talking about ARM.

	-hpa


