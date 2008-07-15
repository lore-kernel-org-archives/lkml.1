Return-Path: <linux-kernel-owner+w=401wt.eu-S1760485AbYGOR4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760485AbYGOR4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbYGOR42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:56:28 -0400
Received: from mail.lang.hm ([64.81.33.126]:40530 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621AbYGOR41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:56:27 -0400
Date: Tue, 15 Jul 2008 10:56:34 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Willy Tarreau <w@1wt.eu>, David Miller <davem@davemloft.net>,
       jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       dwmw2@infradead.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <alpine.LFD.1.10.0807150843580.3017@woody.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0807150933470.16109@asgard.lang.hm>
References: <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <487C09EB.1050903@garzik.org> <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org> <20080714.194032.117461306.davem@davemloft.net> <alpine.LFD.1.10.0807141947540.3017@woody.linux-foundation.org>
 <20080715045848.GG1369@1wt.eu> <alpine.LFD.1.10.0807150747540.3017@woody.linux-foundation.org> <alpine.DEB.1.10.0807150759020.6370@asgard> <alpine.LFD.1.10.0807150843580.3017@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008, Linus Torvalds wrote:

> On Tue, 15 Jul 2008, david@lang.hm wrote:
>>
>> has a standard been defined for how to maintain different versions of firmware
>> for different versions of drivers yet?
>
> No. We haven't had that possibility, probably largely because we haven't
> even really had the ability (Davem and Jeff talk about "choice" and how
> request_firmware() supposedly removes it, but they ignore the fact that it
> very much cuts the other way too - request_firmware() _adds_ choice and
> makes it easier for people to try to upgrade firmware without upgrading
> the kernel).

and they aren't objecting to this choice being added. they just want to 
keep the choice of working the other way (although they implicitly are 
saying that they won't be doing a lot of testing of different firmware 
versions becouse they do want to work the other way)

David Lang
