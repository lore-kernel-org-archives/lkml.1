Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab0BSM1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 07:27:17 -0500
Received: from mail-iw0-f196.google.com ([209.85.223.196]:53122 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab0BSM1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 07:27:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rHa3vXhxlYPMDXwGeson7Qne1ME/fvd9z2zKEZo4lv9u3XBdybR5EYzHxo9jLR/R2z
         VkGLsjaKrgbl+O1Kw3IJuPYIQwQdAkwt7ijf2DFxyHYBtnYuTMLs0wbc9b7SiLTc3pwX
         QmuPeeHh+XCTWZmGCmLZN+MK45vrIYcSWwSu4=
MIME-Version: 1.0
In-Reply-To: <628d1651002190423s4590bbc5x2eeff6792619f591@mail.gmail.com>
References: <628d1651002070324w424012eanda9392db26331905@mail.gmail.com>
	 <b6fcc0a1002190344s75ecfcf6y625591a0fa8e9869@mail.gmail.com>
	 <628d1651002190357q1b17cf76o6585ce957d610ed8@mail.gmail.com>
	 <b6fcc0a1002190402y7aeef6bana21ad7d54a32777a@mail.gmail.com>
	 <628d1651002190423s4590bbc5x2eeff6792619f591@mail.gmail.com>
Date: Fri, 19 Feb 2010 14:27:14 +0200
Message-ID: <b6fcc0a1002190427k735dc6a8ha88cb79b4d333c3e@mail.gmail.com>
Subject: Re: [PATCH] LSM: add static to security_ops variable
From: Alexey Dobriyan <adobriyan@gmail.com>
To: wzt wzt <wzt.wzt@gmail.com>
Cc: linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, jmorris@namei.org,
       eparis@parisplace.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 2:23 PM, wzt wzt <wzt.wzt@gmail.com> wrote:
>> It's not a barrier, it's garbage. Once you know the adress security_ops
>> ended up at, you simply write to it.
>
> How to find the security_ops address if the variable is static? Would
> you please make an example?

See /proc/kallsyms .

>> Not that easily, but they still can.
> That's why i suggest to make the variable to static, if you had wrote
> a rootkit, you will find that in kernel 2.4.x, there are many many
> rootkits, but in kernel 2.6.x, rootkit became fewer. Not all the
> kernel driver writers can master this method to find the variable's
> address.

Please.

> The patch also delete the secondary_ops variable.
