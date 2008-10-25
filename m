Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251AbYJYUhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbYJYUhL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 16:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbYJYUg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 16:36:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:34191 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYJYUg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 16:36:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kB+tjOnbkS/h2K8l0lUzbS1aAogIUjLv5RUUJZ9WzeGQVUYIP9150ET/YKyQ59ZnJ3
         4REhMhGBdHJ6KJCNySfURfzJT1ZkfeFq7WV6Yx/GcPOGjdo8v04JCz9gbWvXONcKHUHo
         grB6VR3B1wliw078o6CkspnvU0d5Jl7f1Yv7c=
Message-ID: <49038365.4070001@gmail.com>
Date: Sat, 25 Oct 2008 13:36:53 -0700
From: walt <w41ter@gmail.com>
User-Agent: Thunderbird/3.0a2pre (X11; 2008102512)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: commit a802dd0e breaks console keyboard input
References: <49011234.7090902@gmail.com> <20081024110742.GD4620@osiris.boeblingen.de.ibm.com> <alpine.LNX.2.00.0810240552320.2613@x9.ybpnyarg> <20081024194414.GB4155@osiris.boeblingen.de.ibm.com> <490256B7.1050906@gmail.com> <20081025141622.GA4397@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20081025141622.GA4397@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> On Fri, Oct 24, 2008 at 04:13:59PM -0700, walt wrote:
>>> Please try the patch below. It basically reverts the whole stop_machine
>>> patches. That way we should know if it really comes from the moved init
>>> call or if it is some other weird bug. I would have expected more bug
>>> reports if the stop_machine patches would be broken. Hmmm...
>> <second patch snipped for brevity>
>>
>> Yes your second patch fixes the keyboard problem, thanks.  The lack of
>> other complainers is what made me think of a BIOS bug, but that's just
>> wild guesswork on my part.  I'm happy to keep trying patches if you can
>> keep making them :-)
>
> Thanks a lot for testing and your patience!
> The patch below moves the init call to its old place but makes the
> stop_machine initialization happen later. I added a BUG_ON to catch possible
> early calls, but there shouldn't be any. I think the patch should solve
> the regression you are seeing. Could you give it a try please?
> The patch applies on top of latest Linus' git tree...

<patch snipped for brevity>
Yes, everything seems back to normal with this patch, thanks.

