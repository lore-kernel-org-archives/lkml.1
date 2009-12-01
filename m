Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZLAGnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZLAGnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 01:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbZLAGna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 01:43:30 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34751 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbZLAGn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 01:43:29 -0500
Message-ID: <4B14BB17.9010600@cs.helsinki.fi>
Date: Tue, 01 Dec 2009 08:43:35 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Adrian von Bidder <avbidder@fortytwo.ch>
CC: Peter Feuerer <peter@piie.net>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: acerhdf: stilll fighting between kernel and BIOS?
References: <200911200823.58897@fortytwo.ch> <200911231018.00163@fortytwo.ch> <84144f020911230158lecd54c2xbf5380602c02c2fd@mail.gmail.com> <200911301902.42262@fortytwo.ch>
In-Reply-To: <200911301902.42262@fortytwo.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian von Bidder kirjoitti:
> On Monday 23 November 2009 10.58:54 Pekka Enberg wrote:
>> On Mon, Nov 23, 2009 at 11:17 AM, Adrian von Bidder
>>
>> <avbidder@fortytwo.ch> wrote:
>>> Heyho!
>>>
>>> On Sunday 22 November 2009 22.27:50 Peter Feuerer wrote:
>>>> issues with AOA 150 netbooks should be solved with current 2.6.32-git
>>>>  tree. You can also try to use latest acerhdf of http://piie.net
>>> Seems to work fine.  That was the fix I thought was already included in
>>> 2.6.31.
>> Is that commit ded0cdfc6a7673916b0878c32fa8ba566b4f8cdb ("acerhdf: fix
>> fan control for AOA150 model")? Should it go to -stable?
> 
> Sorry for not answering sooner.
> 
> I don't really have time to recompile / test more at this time; in any case, 
> I think it's just a minor annoyance and not what I'd feed into a "fixes 
> only" tree.  (I'm not involved in kernel development in any way, but I 
> thought that the stable tree should be quite limited in what goes in?)

Your call. The rules of stable are pretty simple: (1) the patch needs to 
fix a _real_ problem and (2) it needs to be rather small. AFAICT, both 
apply here.

			Pekka
