Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbYATNnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbYATNnQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 08:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYATNnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 08:43:01 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:42205 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbYATNnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:43:00 -0500
Message-ID: <47934FF5.4010904@davidnewall.com>
Date: Mon, 21 Jan 2008 00:13:17 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
References: <20080119045918.GA12215@basil.nowhere.org>	<4792B191.2060801@davidnewall.com>	<20080120031153.GB6275@one.firstfloor.org>	<4792D221.1010704@davidnewall.com>	<20080120051822.GB19784@one.firstfloor.org>	<4792DD22.4070902@davidnewall.com> <20080120130633.76c16d67@lxorguk.ukuu.org.uk>
In-Reply-To: <20080120130633.76c16d67@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> It's not necessarily that simple.  It might be for KFC and Dominoes, but
>> for others, SCO is not the complete story.  Many legacy systems are
>> written in COBOL, and must pay a per-seat licence for that on top of the
>> per-seat licence for UNIX.  It is these systems that are most attracted
>> towards SCO compatibility.
>>     
>
> And they mostly use microfocus cobol which is available on Linux
Or RM Cobol, which is also available on Linux.  Both of these require
significant expense in new licences.

> or they do a quick port to the fujitsu cobol->java vm translator.
>   
I don't know of this thing, but I have looked, on behalf of a colleague,
for tools that can compile his existing COBOL source, and found only
partial solutions (i.e. found nothing.)

> There are people in this community who deal day in and day out with
> migrations. I don't hear a whisper of concern from those I deal with
> about losing iBCS. 
Well, I'm whispering:  The cost is that something desirable but
incomplete would be removed.  While it's there it's a constant source of
irritation to those in the know.  Once removed it can be forgotten.  So
the cost is really that iBCS2 compatibility becomes less likely.  What's
the benefit in removing it?  Up to 20 cycles per exec?  That's nothing.
