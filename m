Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbYGONOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbYGONOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 09:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbYGONOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 09:14:42 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:40009 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbYGONOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 09:14:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rPwjqyvYi94t4BtXw78sRjvVyqAo1Bh1WwWXU7KX0XegtG6/MB/cR3wfw+hFhmfBgs
         SfgCT0hKjYs6sTJoVsftFnYzq+ajEDzDaIdno8tA2Ehs9sC2LE/4RY+FU/suZ+Au6VOm
         HDEMach+ZeMhmSQMk3J0rOlI6wTtc+V4C7qDY=
Message-ID: <b647ffbd0807150614j38204f41q3e7b4ed0ffff101b@mail.gmail.com>
Date: Tue, 15 Jul 2008 15:14:38 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Gregory Haskins" <ghaskins@novell.com>
Subject: Re: [sched-devel, patch-rfc] rework #2 of "prioritize non-migratable tasks over migratable ones"
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <487C6873.BA47.005A.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214947935.5658.11.camel@earth>
	 <b647ffbd0807140750r54e5139aj7b25a28ef7ca247e@mail.gmail.com>
	 <487C6873.BA47.005A.0@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/15 Gregory Haskins <ghaskins@novell.com>:
>>>> On Mon, Jul 14, 2008 at 10:50 AM, in message
> <b647ffbd0807140750r54e5139aj7b25a28ef7ca247e@mail.gmail.com>, "Dmitry
> Adamushko" <dmitry.adamushko@gmail.com> wrote:
>> 2008/7/1 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
>>>
>>> Finally, this new version compiles and boots (applied a minor compilation
>> fix).
>>> Functionality is not yet fully tested though.
>>>
>>> It's on top of today's tip tree.
>>>
>>> Any objections to this approach?
>>
>> [ ping ]
>>
>> Gregory or anyone else, any feedback on this one?
>
> Hi Dmitry,
>  A brief inspection of the patch looks good.  I am still not convinced we need to worry
> about this condition anymore, however.

Neither am I.

It's just that (I think):

(a) either we remove this whole new 'concept' (as it's implemented
now) completely;
(b) or do it in a more generic way (like with this patch).

Thanks for the feedback!

>
> Regards,
> -Greg

-- 
Best regards,
Dmitry Adamushko
