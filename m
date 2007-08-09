Return-Path: <linux-kernel-owner+w=401wt.eu-S937363AbXHIHEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937363AbXHIHEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 03:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759970AbXHIHEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 03:04:25 -0400
Received: from gw.goop.org ([64.81.55.164]:39418 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917AbXHIHEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 03:04:24 -0400
Message-ID: <46BABC0F.5070002@goop.org>
Date: Thu, 09 Aug 2007 00:02:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <glommer@gmail.com>
CC: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 25/25] [PATCH] add paravirtualization support for x86_64
References: <11865467522495-git-send-email-gcosta@redhat.com>	 <1186546820708-git-send-email-gcosta@redhat.com>	 <11865468243612-git-send-email-gcosta@redhat.com>	 <11865468321629-git-send-email-gcosta@redhat.com>	 <11865468362401-git-send-email-gcosta@redhat.com>	 <11865468394005-git-send-email-gcosta@redhat.com>	 <11865468431616-git-send-email-gcosta@redhat.com>	 <1186546847263-git-send-email-gcosta@redhat.com>	 <11865468513077-git-send-email-gcosta@redhat.com>	 <46BAB5C8.5090906@goop.org> <5d6222a80708090002y7fdc6f2dw1dbacd3d27a86433@mail.gmail.com>
In-Reply-To: <5d6222a80708090002y7fdc6f2dw1dbacd3d27a86433@mail.gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
>>> +/*
>>> + * integers must be use with care here. They can break the PARAVIRT_PATCH(x)
>>> + * macro, that divides the offset in the structure by 8, to get a number
>>> + * associated with the hook. Dividing by four would be a solution, but it
>>> + * would limit the future growth of the structure if needed.
>>>
>>>       
>> Why not just stick them at the end of the structure?
>>     
>
> Does it really matter?
>   

Well, yes, if alignment is an issue.


    J
