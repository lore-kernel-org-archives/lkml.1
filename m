Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbYJVCh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbYJVCh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 22:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbYJVCht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 22:37:49 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:50346 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbYJVCht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 22:37:49 -0400
X-IronPort-AV: E=Sophos;i="4.33,461,1220241600"; 
   d="scan'208";a="61451210"
Message-ID: <48FE91AE.4010009@analog.com>
Date: Wed, 22 Oct 2008 10:36:30 +0800
From: Bryan Wu <bryan.wu@analog.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Jesper Nilsson <jesper.nilsson@axis.com>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Mikael Starvik <mikael.starvik@axis.com>
Subject: Re: [RFC] CRIS: Move header files from include to arch/cris
References: <20081021164211.GG24715@axis.com> <8bd0f97a0810211046n2e32868fu1a58cc9123da7c6d@mail.gmail.com>
In-Reply-To: <8bd0f97a0810211046n2e32868fu1a58cc9123da7c6d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Oct 2008 02:35:43.0940 (UTC) FILETIME=[E1BF1840:01C933EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Tue, Oct 21, 2008 at 12:42, Jesper Nilsson <jesper.nilsson@axis.com> wrote:
>   
>> That means that the machine dependent header files are moved to
>> arch/cris/mach-{fs,a3}/include, while the common and architecture
>> dependent files are moved to arch/cris/include.
>>
>> It is mainly this I'd like some input on, since most other ports
>> that have moved their header files have put all headers in arch/*/include.
>>     
>
> that seems like a fairly obvious good idea to me ... i'm thinking we
> should do it for Blackfin as well ...
> -mike
>   
For moving machine header files to 
arch/blackfin/include/asm/mach-bf{527, 533, 537, 538, 548, 561},  we 
need to set a link such as  arch/blackfin/include/asm/mach -> 
arch/blackfin/include/asm/mach-bf527, because tons of drivers use the 
header file <asm/mach/xxxx.h>.

But we don't like to setup a link that is the one reason we move our 
header file from include/asm-blackfin to our arch/blackfin/include/asm.

-Bryan
