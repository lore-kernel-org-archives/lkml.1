Return-Path: <linux-kernel-owner+w=401wt.eu-S935831AbYBVWfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935831AbYBVWfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757248AbYBVWfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:35:14 -0500
Received: from gw.goop.org ([64.81.55.164]:42265 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758587AbYBVWfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:35:12 -0500
Message-ID: <47BF4D5B.5020509@goop.org>
Date: Fri, 22 Feb 2008 14:31:55 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Markus Armbruster <armbru@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
       linux-fbdev-devel@lists.sourceforge.net, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       linux-input@vger.kernel.org, adaplas@pol.net, akpm@linux-foundation.org,
       jayakumar.lkml@gmail.com
Subject: Re: [PATCH 2/2] xen pvfb: Para-virtual framebuffer,	keyboard and
 pointer driver
References: <871w76ejdg.fsf@pike.pond.sub.org>	<87skzmd4qc.fsf@pike.pond.sub.org> <47BDDF97.7070001@goop.org> <8763whbiy8.fsf@pike.pond.sub.org>
In-Reply-To: <8763whbiy8.fsf@pike.pond.sub.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Armbruster wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
>   
>> Markus Armbruster wrote:
>>     
>>> This is a pair of Xen para-virtual frontend device drivers:
>>> drivers/video/xen-fbfront.c provides a framebuffer, and
>>> drivers/input/xen-kbdfront provides keyboard and mouse.
>>>   
>>>       
>> Unless they're actually inter-dependent, could you post this as two
>> separate patches?  I don't know anything about these parts of the
>> kernel, so it would be nice to make it very obvious which changes are
>> fb vs mouse/keyboard.
>>     
>
> I could do that do that, but the intermediate step (one driver, not
> the other) is somewhat problematic: the backend in dom0 needs both
> drivers, and will refuse to complete device initialization unless
> they're both present.
>   

That's OK.  In that case keep them together.

    J
