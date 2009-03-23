Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbZCWNWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbZCWNWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 09:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbZCWNWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 09:22:08 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53681 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZCWNWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:22:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pIR/l9Tw9Exv8IjwN7sowjCN4aRIAPY9q6SImRbRms/4pzggMmqix28Y5d0te/YZVv
         qUMqjqgrRxlC8iPX7pqg8EU47t92XSEWs9nuz9PEo+0gpxRlhBwm3CSjBqMWHGHWUWPF
         ryAK5hu3J8QjVeeOHyqcxFP0K+m1Tl3aZ99AY=
MIME-Version: 1.0
In-Reply-To: <20090323085024.GA8897@frolo.macqel>
References: <20090319181120.GA18034@frolo.macqel>
	 <20090323085024.GA8897@frolo.macqel>
Date: Mon, 23 Mar 2009 14:21:59 +0100
X-Google-Sender-Auth: edbf488de769b51c
Message-ID: <cabda6420903230621k6ba147cqb055c724777dde6b@mail.gmail.com>
Subject: Re: [PATCH] parport netmos 9845 & 9855 1P4S fixes
From: christian pellegrin <chripell@fsfe.org>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org, linux-parport@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 9:50 AM, Philippe De Muyter <phdm@macqel.be> wrote:
> Hello list,
>

Hi,

> Christian, can you verify that the patch below works for your
> netmos 9855 2P2S board ?

I compiled a kernel with this patch and I see both serial and both
parallel ports in dmesg. I tested the serial ports and they work.
Unfortunately I don't have any device around to test the parallel
ports. You know, USB killed the pport stars.

> Last fix of Christian Pellegrin for 9855 2P2S broke support for 9855 1P4S,
> and works only by side-effect for the first parallel port of a 2P2S,

sorry for that, I didn't know about the 1P4S version. This is the
reason why I changed netmos9855 entry directyl.

-- 
Christian Pellegrin, see http://www.evolware.org/chri/
"Real Programmers don't play tennis, or any other sport which requires
you to change clothes. Mountain climbing is OK, and Real Programmers
wear their climbing boots to work in case a mountain should suddenly
spring up in the middle of the computer room."
