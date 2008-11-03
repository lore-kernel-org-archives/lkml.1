Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbYKCOvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbYKCOvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYKCOvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:51:06 -0500
Received: from ik-out-1112.google.com ([66.249.90.179]:40059 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362AbYKCOvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:51:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Z441Ki+2eqb8J425QvF2NnkV5GWRYitdQUaXK8/3h1KhohjS+kn/yfra/X7b3Obx/0
         R5IfwBSiVKVXGU+O5/C9vMZYhhjC3Yxt5rSmSMADMsz4MO4YPeOLEENeEu67x9BC49XC
         TvGc4ya3C733gPKin6qbe36+5ODLHtDLQMxTA=
Message-ID: <490F0FCF.4060905@gmail.com>
Date: Mon, 03 Nov 2008 15:50:55 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ivan Vecera <ivecera@redhat.com>
CC: Krzysztof Halasa <khc@pm.waw.pl>, Francois Romieu <romieu@fr.zoreil.com>,
       Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, Edward Hsu <edward_hsu@realtek.com.tw>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: r8169 MAC addresses broken
References: <490380C8.6070003@simon.arlott.org.uk>	<4903947A.3060206@gmail.com>	<20081025223443.GA30913@electric-eye.fr.zoreil.com>	<4904A7C5.7090801@gmail.com>	<20081026174654.GB24790@electric-eye.fr.zoreil.com>	<4906E4BE.9050304@gmail.com> <m3mygozvd4.fsf@maximus.localdomain> <490718C7.3010501@gmail.com> <490EBE83.7030309@redhat.com>
In-Reply-To: <490EBE83.7030309@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2008 10:04 AM, Ivan Vecera wrote:
> Jiri Slaby wrote:
>> On 10/28/2008 02:45 PM, Krzysztof Halasa wrote:
>>> Jiri Slaby <jirislaby@gmail.com> writes:
>>>
>>>>> Same thing if you unplug the battery ?
>>>> Thanks, now it seems to be OK.
>>> Well, perhaps reverting that patch was a bit premature?
>> No, it helped after reverting that patch. I think we don't want defunct 2.6.28
>> with these nics.
> I cannot agree.

You want defunct r8169 in 2.6.28? Or cannot agree with what?

> IMO the problem was in the first version of the patch that didn't
> check for invalid (zeroed) MAC address. In this case is necessary to power-off (desktop
> case) or unplug the battery (notebook case).

I see no updated patch in this thread to test -- am I missing something?
