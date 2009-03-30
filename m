Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbZC3Q6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbZC3Q6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 12:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbZC3Q6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 12:58:32 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:63008 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbZC3Q6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 12:58:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=I0cPu99EpjQr4fiXSXMTn2TnE222nucf4tmvFYBa9eouhYE2kJwTB7WhhS1p4d9yNE
         YXJwOWocAL3CDcfw+8KlidUsw+0o3OwaHKXHavi3NX1t0EK4pvOcUaYKqOEZnqLCaOGR
         auiNz2awVU/aEkdC4470l7A3VgOF8/w6a8TkE=
MIME-Version: 1.0
In-Reply-To: <20090330085952.GB3837@linux.vnet.ibm.com>
References: <1231336282-22283-1-git-send-email-jirislaby@gmail.com>
	 <1231338965-796-1-git-send-email-jirislaby@gmail.com>
	 <20090107152208.GB4207@linux.vnet.ibm.com>
	 <4964CAAA.3040801@gmail.com>
	 <25891f3e0902012357n21e7bc2fmc59fb2a842631651@mail.gmail.com>
	 <20090215134702.GA10180@hash.localnet> <49A9C3D7.8060706@gmail.com>
	 <20090330085952.GB3837@linux.vnet.ibm.com>
Date: Mon, 30 Mar 2009 12:58:28 -0400
X-Google-Sender-Auth: c93f08b8cc037b84
Message-ID: <b6c5339f0903300958m587cde69o44ae24d0609228ba@mail.gmail.com>
Subject: Re: [PATCH 1/1] ath5k: fix hw rate index condition
From: Bob Copeland <me@bobcopeland.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Dhaval Giani <dhaval.lists@thegianis.in>,
       linville@tuxdriver.com, davem@davemloft.net,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 4:59 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> Where is the fix? Is it merged in? I still see this happen on 2.6.29
>
> thanks,

It's in b726604706ad88d8b28bc487e45e710f58cc19ee in Linus' tree, after
2.6.29.  You still might get a warning, but this time from the driver
side instead of higher up the stack -- if you do please post it.

-- 
Bob Copeland %% www.bobcopeland.com
