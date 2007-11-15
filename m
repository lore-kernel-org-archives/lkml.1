Return-Path: <linux-kernel-owner+w=401wt.eu-S932542AbXKOUga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542AbXKOUga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760878AbXKOUgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:36:22 -0500
Received: from smtp161.sat.emailsrvr.com ([66.216.121.161]:50650 "EHLO
	smtp161.sat.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760505AbXKOUgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:36:21 -0500
Message-ID: <473CABE7.5030205@keyspan.com>
Date: Thu, 15 Nov 2007 12:28:23 -0800
From: Lucy McCoy <lucy@keyspan.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: bbpetkov@yahoo.de, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] keyspan: init termios properly
References: <20071103100301.GA5615@gollum.tnic>	<473C86A2.1060505@keyspan.com> <20071115120909.133e8e52.akpm@linux-foundation.org>
In-Reply-To: <20071115120909.133e8e52.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, it will break things. I'll try to get to it soon...

Andrew Morton wrote:
> On Thu, 15 Nov 2007 09:49:22 -0800 Lucy McCoy <lucy@keyspan.com> wrote:
>
>   
>> Greg & Boris,
>>
>> I've been out of town and just saw this.
>>
>> This patch will work with the 19HS but WILL BREAK all other Keyspan
>> adapters.  It will take me a few days to get to looking at a correct fix but
>> that keyspan_send_setup(port, 1) (and the '1' is the important part) 
>> must happen once
>> when the port is first opened.  The cflag can just be set to whatever 
>> the normal default
>> is for your serial environment.  What are the defaults?
>>
>>     
>
> drat, this patch just went into mainline.
>
> If you're sure that it'll break things, I'll revert it while you cook up
> something better, OK?
>
>
>   
