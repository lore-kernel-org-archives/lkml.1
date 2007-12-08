Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbXLHP2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbXLHP2U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 10:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbXLHP2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 10:28:05 -0500
Received: from rtr.ca ([76.10.145.34]:3347 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbXLHP2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 10:28:04 -0500
Message-ID: <475AB802.1090003@rtr.ca>
Date: Sat, 08 Dec 2007 10:28:02 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Holger Hoffstaette <holger@wizards.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: Reproducible data corruption with sendfile+vsftp - splice	regression?
References: <pan.2007.11.29.23.42.52.661624@wizards.de> <474FC4D9.3020506@cosmosbay.com> <pan.2007.11.30.09.20.24.737500@wizards.de> <475055EE.9060105@hp.com> <pan.2007.12.02.16.00.03.568000@wizards.de> <pan.2007.12.02.20.49.42.675000@wizards.de> <20071205225429.GA10186@electric-eye.fr.zoreil.com> <pan.2007.12.06.09.28.08.913625@wizards.de> <20071206184426.GA32599@electric-eye.fr.zoreil.com>
In-Reply-To: <20071206184426.GA32599@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu wrote:
> Holger Hoffstaette <holger@wizards.de> :
> [...]
>> Maybe turning off sendfile or NAPI just lead to random success - so far it
>> really looks like tso on the r8169 is the common cause.
> 
> TSO on the r8169 is the magic switch but the regression makes imvho more
> sense from a VM pov:
> 
> - the corrupted file has the same size as the expected file
> - the corrupted file exhibits holes which come as a multiple of 4096 bytes
>   (8*4k, 2 places, there may be more)
...

That's interesting.  I had the those exact same symptoms here
with copying data to/from a USB stick recently.
But that stick died completely shortly thereafter,
so this was written-off as "bad hardware".

Strange that you see the same symptoms from a different scenario.
Probably no relationship there, but ..

