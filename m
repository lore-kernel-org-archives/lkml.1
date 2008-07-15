Return-Path: <linux-kernel-owner+w=401wt.eu-S1760130AbYGOAGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130AbYGOAGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 20:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760185AbYGOAFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 20:05:43 -0400
Received: from mail.lang.hm ([64.81.33.126]:43703 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760171AbYGOAFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 20:05:42 -0400
Date: Mon, 14 Jul 2008 17:06:06 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Arjan van de Ven <arjan@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <20080714165956.7fe2d4ee@infradead.org>
Message-ID: <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008, Arjan van de Ven wrote:

> On Mon, 14 Jul 2008 16:41:19 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> On Mon, 14 Jul 2008 16:23:26 -0700
>> David Woodhouse <dwmw2@infradead.org> wrote:
>>
>>> Linus, please pull from the for-2.6.27 branch of:
>>> 	git://git.infradead.org/users/dwmw2/firmware-2.6.git
>>> for-2.6.27
>>
>> The firmware flamewars seem to have subsided lately.  Is everyone
>> happy with this now?
>>
>
> this seems to have left the contentious pieces out....

almost, the one thing that this could have done would be to offer an 
option to bundle the firmware with the module. currently it offers the 
option to load the firmware at the same time as the module, not _quite_ 
the same thing.

there was also the issue that was raised about how to handle firmware 
during suspend/resume. I don't remember seeing a happy solution to that 
one.

David Lang
