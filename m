Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490Ab0A0Pl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab0A0Pl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 10:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353Ab0A0PlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 10:41:25 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:45730 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932150Ab0A0PlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 10:41:23 -0500
Message-ID: <75047b2add1f00d12eeb359b9645bd90.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <201001271635.26295.oliver@neukum.org>
References: <3026aa4769d53c108ee0671f2b17c668.squirrel@intranet.cs.nmsu.edu>
    <alpine.LRH.2.00.1001270018570.15694@twin.jikos.cz>
    <fd35fcc83b1a4ae5dd4daba3cf596c5d.squirrel@intranet.cs.nmsu.edu>
    <201001271635.26295.oliver@neukum.org>
Date: Wed, 27 Jan 2010 08:41:15 -0700
Subject: Re: usbhid driver: replacing resume or using a post resume function
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Oliver Neukum" <oliver@neukum.org>
Cc: "Jiri Kosina" <jkosina@suse.cz>, "Linux" <linux-kernel@vger.kernel.org>,
       "Linux USB" <linux-usb@vger.kernel.org>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Mittwoch, 27. Januar 2010 15:57:48 schrieb Rick L. Vinyard, Jr.:
>> I think the most common case would be for something like the G13 to
>> re-establish settings, which from the few devices I'm familiar with
>> would
>> need to restart the hid subsystem first and then re-establish through
>> feature reports, et. al. after the hid_resume().
>>
>> Also, that means that usbhid's hid_resume() doesn't need to be exposed
>> in
>> the API, or even need to be usb specific.
>
> If you do do this please document that you may use only GFP_NOIO
> and GFP_ATOMIC in that context.
>
> 	Regards
> 		Oliver
>

Will do.

