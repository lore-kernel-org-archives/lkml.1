Return-Path: <linux-kernel-owner+w=401wt.eu-S1751499AbYH2Erc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbYH2Erc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 00:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbYH2ErY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 00:47:24 -0400
Received: from smtp101.prem.mail.sp1.yahoo.com ([98.136.44.56]:35899 "HELO
	smtp101.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750799AbYH2ErY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 00:47:24 -0400
X-YMail-OSG: 1Q_p9ZcVM1mYStIbziL.jIGmj9owUcMBwtKco.pC5rwAdhMRovXYz9O9U0LbhoP34X2wsYHm.bbsbwOTKNeRIocho7YTLH927vrvBTdhtQgKaOgwc6nR3R0oSiTWaXe1GcpYchQBggkImvBvXl6diqpC
X-Yahoo-Newman-Property: ymail-3
Message-ID: <48B77F53.6080200@schaufler-ca.com>
Date: Thu, 28 Aug 2008 21:47:15 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
CC: Theodore Tso <tytso@mit.edu>, Markku Savela <msa@moth.iki.fi>,
       Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: Frustrated with capabilities..
References: <87hc96by8x.fsf@burp.tkv.asdf.org>	 <20080828141826.GA6797@ucw.cz>	 <200808281445.m7SEjYsB007502@burp.tkv.asdf.org>	 <20080828174854.GM26987@mit.edu> <1219957399.2627.127.camel@moss-terrapins.epoch.ncsc.mil>
In-Reply-To: <1219957399.2627.127.camel@moss-terrapins.epoch.ncsc.mil>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Quigley wrote:
> On Thu, 2008-08-28 at 13:48 -0400, Theodore Tso wrote:
>   
>> On Thu, Aug 28, 2008 at 05:45:34PM +0300, Markku Savela wrote:
>>     
>>>> From: Pavel Machek <pavel@suse.cz>
>>>>         
>>>> Yes, you need upcoming filesystem capabilities.  Binary may not
>>>> inherit capabilities unless filesystem flags permit that.
>>>>         
>>> I think this is wrong. Normal executables inherit uid/gid and
>>> supplementary groups by default. Why should capabilities be any
>>> different?
>>>       
>> Well, because that's not the what the POSIX draft specification (and
>> the rest of the Unix industry who were striving to meet the US
>> Department of Defense's "B2 by '92" initiative) ended up implementing.
>>     
>
> Minor nit. It was actually C2(Controlled Access Protection) by '92 which
> is mainly just DAC protections as opposed to B2(Structured Protection)
> which also included MAC policies and Sensitivity labels in addition to
> DAC protections

But the fun part was that the evaluation requirements for B1,
which fell in between C2 and B2 (the order from least secure to
most was D, C1, C2, B1, B2, B3, A1, and "Beyond A1") where so
close to those for C2 that everyone implemented B1, which did
include MAC policy in the form of Bell and LaPadula sensitivity.
The privilege model (now called capabilities, and you have to buy
me a beer to get the whole story) does not actually come in the
requirements until B3, although some people will argue that it
was intended they be included at B2. Even though no one even tried
a B3 and no one succeeded at B2 everyone did capabilities based
on one of the drafts or another.

Anyone who thinks that the capability scheme is wrong headed is
encouraged to read the P1003.1e/2c (withdrawn) DRAFT. It's on
the web in several places. You may end up still thinking it's
wrong, but at least you will have seen how the arguments got
hashed out.

And we're still not talking about the Jackson Hole meeting.


