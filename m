Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245Ab0ATTxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab0ATTxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 14:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217Ab0ATTxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 14:53:37 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:44828 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab0ATTxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 14:53:36 -0500
X-Greylist: delayed 2397 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jan 2010 14:53:36 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pJ8m8FBggi0GVN42yAUklAwLGS13D+jJEH/itj1dZvaLMOU6268+eTzJsnYxEe/kFb
         SiqE9S6ibyDcvXUh6gXx5PIIdbe8/umW8rKd0KmcKM0nrfxL61/Zc6zQH3bgK2w7P3bL
         VOuUhho3p9tJKr8XZb49CV9smDG4pnjCJklLI=
Message-ID: <4B575F7E.4070107@gmail.com>
Date: Wed, 20 Jan 2010 11:54:38 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Bastien Nocera <hadess@hadess.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
References: <1264011793.1735.3683.camel@localhost.localdomain>	 <4B575621.9050204@gmail.com> <1264016268.1735.3915.camel@localhost.localdomain>
In-Reply-To: <1264016268.1735.3915.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/10 11:37, Bastien Nocera wrote:
> On Wed, 2010-01-20 at 11:14 -0800, Justin P. Mattock wrote:
>> On 01/20/10 10:23, Bastien Nocera wrote:
>>> As those computers never had any i8042 controllers, and the
>>> current lookup code could potentially lock up/hang/wait for
>>> timeout for long periods of time.
>>>
>>> Fixes intermittent hangs on boot on a MacbookAir1,1
> <snip>
>> glad you submitted this. i.g. been looking at some dmi
>> blacklist thing over here(been racking my brain around
>> a bit, and seeing your idea simplified it a bit more for me).
>
> Yeah, dmi_check_system() returns the number of matches. I had to look up
> the code to see what it did :)
>
>> as for what you have here, do you think individually
>> defining each machine is safer, or does it not matter?
>
> For this particular case, it's not necessary, as none of the Apple
> machines ever had any i8042 hardware. Or at least that's what Peter
> Jones told me, and I have no reasons to doubt him.
>
> Cheers
>
>
ahh.. because of the no i8042..

Justin P. Mattock
