Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbYHHPGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbYHHPGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 11:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755659AbYHHPGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 11:06:10 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:61401 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbYHHPGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 11:06:09 -0400
Message-ID: <489C60D3.2040201@nortel.com>
Date: Fri, 08 Aug 2008 09:05:55 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: including .c files ?
References: <ac9c93b10808080425p321fac13y72a5b2b4e67ee6a9@mail.gmail.com> <m3abfnk296.fsf@maximus.localdomain>
In-Reply-To: <m3abfnk296.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Aug 2008 15:05:59.0786 (UTC) FILETIME=[444CD4A0:01C8F968]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com> writes:
> 
> 
>>Generally I would expect that if the .c file contains some standalone
>>functionality then it should probably be a .c file on its own with a
>>well defined interface.
> 
> 
> Doesn't work when you need conditional compilation.

Sure it does...look at all the kernel Makefiles that compile code based 
on whether a config option is set.

In the case of the scheduler I suspect it's done to break a single 
logical file into several pieces for better readability.

Chris
