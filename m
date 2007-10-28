Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbXJ1QP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbXJ1QP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 12:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbXJ1QPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 12:15:21 -0400
Received: from gw.goop.org ([64.81.55.164]:54613 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbXJ1QPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 12:15:20 -0400
Message-ID: <4724B597.1070806@goop.org>
Date: Sun, 28 Oct 2007 09:15:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Michael Buesch <mb@bu3sch.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [2.6 patch] fix USB_OHCI_HCD_SSB dependencies
References: <20071027010647.GN30533@stusta.de> <20071027085748.GB3742@elte.hu> <20071027134556.GS30533@stusta.de>
In-Reply-To: <20071027134556.GS30533@stusta.de>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sat, Oct 27, 2007 at 10:57:48AM +0200, Ingo Molnar wrote:
>   
>> * Adrian Bunk <bunk@kernel.org> wrote:
>>
>>     
>>> -	depends on USB_OHCI_HCD && (SSB = y || SSB = CONFIG_USB_OHCI_HCD) && EXPERIMENTAL
>>> +	depends on USB_OHCI_HCD && (SSB = y || SSB = USB_OHCI_HCD) && EXPERIMENTAL
>>>       
>> oops, indeed ... my Kconfig fu needs strengthening. Does Kconfig warn 
>> somewhere if it sees an erroneous CONFIG_ token?
>>     
>
> No. IIRC Sam was working in getting warnings for such things, but 
> currently kconfig simply can't know whether it's a bug or OK.
>   

Are there any instances of CONFIG_CONFIG_X?  Doesn't seem like a
terribly sensible name...

    J
