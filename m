Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbYJXXOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbYJXXOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757893AbYJXXOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 19:14:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:1656 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbYJXXOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 19:14:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mpAR/GUeREfABMMhMHnWLj7UQaaV2mouhduRyJUrOOG8zR4JLkbtzELuqSlu8X4oWw
         I5mqoOMyZeR6wckcSveznZgypEte/Wg4myGTWIDeZtDXEIb71l9USAR0dvLk9LN3kLC+
         5zB9GvIXezlbQHcwx5UkVoTXn7He+iLUf9kCI=
Message-ID: <490256B7.1050906@gmail.com>
Date: Fri, 24 Oct 2008 16:13:59 -0700
From: walt <w41ter@gmail.com>
User-Agent: Thunderbird/3.0a2pre (X11; 2008102405)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: commit a802dd0e breaks console keyboard input
References: <49011234.7090902@gmail.com> <20081024110742.GD4620@osiris.boeblingen.de.ibm.com> <alpine.LNX.2.00.0810240552320.2613@x9.ybpnyarg> <20081024194414.GB4155@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20081024194414.GB4155@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> On Fri, Oct 24, 2008 at 05:52:57AM -0700, w41ter@gmail.com wrote:
>> On Fri, 24 Oct 2008, Heiko Carstens wrote:
>>> On Thu, Oct 23, 2008 at 05:09:24PM -0700, walt wrote:
>>>> Hi team,
>>>>
>>>> commit a802dd0eb5fc97a50cf1abb1f788a8f6cc5db635
>>>> Author: Heiko Carstens<heiko.carstens@de.ibm.com>
>>>> Date:   Mon Oct 13 23:50:08 2008 +0200
>>>>
>>>>      Call init_workqueues before pre smp initcalls.
>>>>
>>>> This commit causes the console login prompt to ignore my keystrokes
>>>> so I'm unable to log in (though ssh works fine).  Oddly, if I hit
>>>> ctrl-alt-delete the machine does reboot, but no other keystrokes
>>>> appear on the screen or have any effect that I can detect...

> Please try the patch below. It basically reverts the whole stop_machine
> patches. That way we should know if it really comes from the moved init
> call or if it is some other weird bug. I would have expected more bug
> reports if the stop_machine patches would be broken. Hmmm...

<second patch snipped for brevity>

Yes your second patch fixes the keyboard problem, thanks.  The lack of
other complainers is what made me think of a BIOS bug, but that's just
wild guesswork on my part.  I'm happy to keep trying patches if you can
keep making them :-)
