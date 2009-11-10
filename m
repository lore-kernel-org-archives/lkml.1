Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbZKJWyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbZKJWyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758630AbZKJWyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:54:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38368 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582AbZKJWyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:54:38 -0500
Message-ID: <4AF9ED78.3000106@zytor.com>
Date: Tue, 10 Nov 2009 14:47:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <4AF9B5AB.5010800@zytor.com> <4AF9C3EF.6000705@redhat.com> <4AF9C6AB.8080006@zytor.com> <20091110201602.GA26633@1wt.eu> <20091110205445.GB1407@ucw.cz> <20091110211259.GD26633@1wt.eu> <4AF9D8E2.7050205@zytor.com> <20091110220652.GE26633@1wt.eu> <4AF9E61B.5090407@zytor.com> <20091110222031.GA22911@elte.hu> <20091110224222.GA28648@1wt.eu>
In-Reply-To: <20091110224222.GA28648@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 02:42 PM, Willy Tarreau wrote:
> On Tue, Nov 10, 2009 at 11:20:31PM +0100, Ingo Molnar wrote:
>>
>> * H. Peter Anvin <hpa@zytor.com> wrote:
>>
>>> *THIS* is the kind of complexity that makes me think that having a 
>>> single source for all interpretation done in the kernel is the 
>>> preferred option.
>>
>> Definitely agreed ... The NX code is quite a maze right now, so changes 
>> to it should come generously laced with cleanups.
> 
> BTW, I don't see why we should be impacted by NX. Trying to
> execute from an NX page would return a SEGV, not SIGILL, so
> we should not be bothered, am I wrong ?

Yes.  Consider a page-crossing instruction.

	-hpa
