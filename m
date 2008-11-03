Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbYKCJEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbYKCJEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 04:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbYKCJEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 04:04:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59118 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652AbYKCJE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 04:04:29 -0500
Message-ID: <490EBE83.7030309@redhat.com>
Date: Mon, 03 Nov 2008 10:04:03 +0100
From: Ivan Vecera <ivecera@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Krzysztof Halasa <khc@pm.waw.pl>, Francois Romieu <romieu@fr.zoreil.com>,
       Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, Edward Hsu <edward_hsu@realtek.com.tw>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: r8169 MAC addresses broken
References: <490380C8.6070003@simon.arlott.org.uk>	<4903947A.3060206@gmail.com>	<20081025223443.GA30913@electric-eye.fr.zoreil.com>	<4904A7C5.7090801@gmail.com>	<20081026174654.GB24790@electric-eye.fr.zoreil.com>	<4906E4BE.9050304@gmail.com> <m3mygozvd4.fsf@maximus.localdomain> <490718C7.3010501@gmail.com>
In-Reply-To: <490718C7.3010501@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 10/28/2008 02:45 PM, Krzysztof Halasa wrote:
>> Jiri Slaby <jirislaby@gmail.com> writes:
>>
>>>> Same thing if you unplug the battery ?
>>> Thanks, now it seems to be OK.
>> Well, perhaps reverting that patch was a bit premature?
> 
> No, it helped after reverting that patch. I think we don't want defunct 2.6.28
> with these nics.
I cannot agree. IMO the problem was in the first version of the patch that didn't
check for invalid (zeroed) MAC address. In this case is necessary to power-off (desktop
case) or unplug the battery (notebook case).

> 
>> If removing battery fixes the problem then it's not the EEPROM.
> 
> Agreed.

