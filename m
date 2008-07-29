Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbYG2SZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbYG2SZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 14:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbYG2SZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 14:25:44 -0400
Received: from gw.goop.org ([64.81.55.164]:38945 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbYG2SZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 14:25:43 -0400
Message-ID: <488F60A1.2080902@goop.org>
Date: Tue, 29 Jul 2008 11:25:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Cliff Wickman <cpw@sgi.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       steiner@sgi.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: Comments on UV tlb flushing
References: <488E644B.10801@goop.org>	 <200807291412.18495.nickpiggin@yahoo.com.au>	 <20080729133204.GA13138@sgi.com> <488F2C9B.9070306@goop.org> <86802c440807291113u59ba996dg340c8feba1039f3a@mail.gmail.com>
In-Reply-To: <86802c440807291113u59ba996dg340c8feba1039f3a@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Tue, Jul 29, 2008 at 7:43 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>   
>> Cliff Wickman wrote:
>>     
>>> I think that the Linux distributions are not going to build a special
>>> UV kernel, are they?  So every distro would have to be prompted to turn on
>>> CONFIG_X86_UV, or else their kernel is not going to boot on UV.
>>>
>>>       
>> Distros will generally turn on everything.  You could have it on by default
>> if the kernel is built for CONFIG_X86_GENERICARCH which enables support for
>> other big numa configurations.  I think distros generally build with that
>> enabled anyway.
>>     
>
> config X86_GENERICARCH
>        bool "Generic architecture"
>         depends on X86_32
>   

Ah, overlooked that.

OK, well, either way it still needs to be a separate config option.

    J
