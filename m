Return-Path: <linux-kernel-owner+w=401wt.eu-S1751527AbZLNIO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbZLNIO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 03:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbZLNIO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 03:14:28 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:54011 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbZLNIO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 03:14:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=c/c+msdJADM7RFZLa/wQ/cheKG2d7c7ylZcKTJ2jXYmCXEuwL+fjr/VA0JrnX0C3Te
         xF1UArS2scXrm1GpcjOsucUeRrLFc3vUxxhIUn/q02+bpxvicnFFwT39lVpKaDLM7RcJ
         BAGn267caMSkDnd/HhCiMG8iIf7ugGp3ZwQq4=
MIME-Version: 1.0
In-Reply-To: <4B25EA8B.1030507@grandegger.com>
References: <alpine.DEB.2.00.0912132008100.21225@ayla.of.borg>
	 <4B2552C8.4090105@grandegger.com>
	 <20091213.174020.26980813.davem@davemloft.net>
	 <4B25EA8B.1030507@grandegger.com>
Date: Mon, 14 Dec 2009 09:14:27 +0100
X-Google-Sender-Auth: d27482d8d94c842b
Message-ID: <cabda6420912140014i5693f17p2d00a82ff3a4a3bc@mail.gmail.com>
Subject: Re: [PATCH] can: CAN_MCP251X should depend on HAS_DMA
From: christian pellegrin <chripell@fsfe.org>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: David Miller <davem@davemloft.net>, geert@linux-m68k.org,
       urs.thuermann@volkswagen.de, oliver.hartkopp@volkswagen.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 8:34 AM, Wolfgang Grandegger <wg@grandegger.com> wrote:
> David Miller wrote:
>>
>> I still think it's a reasonable dependency.
>>
>> You're not going to find this device on a s390 system. :-)
>
> OK, we could change that on request.
>
> Wolfgang.
>

Hi, sorry for the late answer. I agree it's a reasonable dependency.
Anyway it's easy to #ifdef it out if anyone cares.

Bye,

-- 
Christian Pellegrin, see http://www.evolware.org/chri/
"Real Programmers don't play tennis, or any other sport which requires
you to change clothes. Mountain climbing is OK, and Real Programmers
wear their climbing boots to work in case a mountain should suddenly
spring up in the middle of the computer room."
