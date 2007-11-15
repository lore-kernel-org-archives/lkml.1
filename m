Return-Path: <linux-kernel-owner+w=401wt.eu-S1762255AbXKOQ3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762255AbXKOQ3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756365AbXKOQ33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:29:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47690 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754567AbXKOQ33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:29:29 -0500
Message-ID: <473C736D.2040307@linux-foundation.org>
Date: Thu, 15 Nov 2007 08:27:25 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
Organization: Linux Foundation
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 08/16] skge: fix ram buffer size calculation
References: <20071115060353.071060513@mini.kroah.org> <20071115064037.GH18951@kroah.com> <alpine.LFD.0.9999.0711150810130.2786@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0711150810130.2786@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Wed, 14 Nov 2007, Greg KH wrote:
>   
>> -stable review patch.  If anyone has any objections, please let us know.
>>
>> ------------------
>> From: Stephen Hemminger <shemminger@linux-foundation.org>
>>
>> patch 7fb7ac241162dc51ec0f7644d4a97b2855213c32 in mainline.
>>
>> This fixes problems with transmit hangs on older fiber based SysKonnect boards.
>>
>> Adjust ram buffer sizing calculation to make it correct on all boards
>> and make it like the code in sky2 driver.
>>     
>
> This one is getting reverted in mainline in about five minutes (unless I 
> find an email from Stephen to address the reported regression - I haven't 
> gone through all my emails yet), so I don't think it should make it into 
> stable.
>
> 			Linus
>   
I can't reproduce the users problem with the hardware I have. And 
without the patch the dual
port board doesn't work. So it is a question of regression, versus 
fixing pre-existing bugs.
I am okay with reverting the patch, as a temporary state, but concerned 
with how
to make progress in fixing this.
