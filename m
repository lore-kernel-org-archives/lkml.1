Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbZCYI2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbZCYI2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbZCYI1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:27:49 -0400
Received: from smtp.nokia.com ([192.100.122.233]:34996 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZCYI1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:27:47 -0400
Message-ID: <49C9EB17.2020408@nokia.com>
Date: Wed, 25 Mar 2009 10:28:07 +0200
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Liam Girdwood <lrg@slimlogic.co.uk>
CC: David Brownell <david-b@pacbell.net>, Mark Brown <broonie@sirena.org.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] regulator: twl4030 VAUX3 supports 3.0V
References: <49B11EB0.30809@nokia.com>	 <200903061116.21544.david-b@pacbell.net>	 <20090306221842.GB15728@sirena.org.uk>	 <200903061448.43749.david-b@pacbell.net>	 <1236599245.6781.86.camel@vega.slimlogic.co.uk>	 <49BF52F9.2030708@nokia.com> <1237290190.6781.313.camel@vega.slimlogic.co.uk>
In-Reply-To: <1237290190.6781.313.camel@vega.slimlogic.co.uk>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2009 08:27:19.0014 (UTC) FILETIME=[83017060:01C9AD23]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liam Girdwood wrote:
> On Tue, 2009-03-17 at 09:36 +0200, Adrian Hunter wrote:
>> Liam Girdwood wrote:
>>> On Fri, 2009-03-06 at 14:48 -0800, David Brownell wrote:
>>>> On Friday 06 March 2009, Mark Brown wrote:
>>>>> Would it make sense to make this platform data so that if a given board
>>>>> requires running the chip like this it can be enabled for those boards
>>>>> but it's not something people might turn on because it seems useful?
>>>> Let's hear if it's actually needed, first.  :)
>>>>
>>>> I coded those tables so that it would be easy to kick in the
>>>> support for out-of-spec operation if it's really needed.  But
>>>> so far we don't know that it's needed, and I'd rather it not
>>>> be too easy to run like that.
>>>>
>>> I've now reverted this patch. 
>> TI say we can use VAUX3 at 3V and expect no problems:
>>
>> http://community.ti.com/forums/p/3777/14574.aspx
>>
>> So how do we do it?
> 
> I'd prefer seeing the reply from Ghandar to David's last question before
> accepting this patch again. It's still not 100% clear from TI, things
> seem a little bit muddled as to whether 3V will be guaranteed to work on
> *all* shipped devices.

Ghandar has responded.  What would you like to do?

