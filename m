Return-Path: <linux-kernel-owner+w=401wt.eu-S1759172AbYHAJyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172AbYHAJyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758240AbYHAJyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:54:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:51219 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758124AbYHAJyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:54:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=S9MG8lCO72zXL73WLkHI7AYrg7eY8OJ5vkBHtsGE/wFR8kMZdP2fJWDINzB2U9WsVH
         2DWgekImuMtbtWrGm3O2iWhJCM7XTQCuLXqWcc4D18+24Bu/gsf0iR6ORtbam5jBA2v/
         iW0KCyjFEGiAB4gqr38bZoxG/l9XRtDSFap3c=
Message-ID: <c4e36d110808010254i2274516q4cef62460fe8e8@mail.gmail.com>
Date: Fri, 1 Aug 2008 11:54:19 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: Sysrq+B doesn't work on my box
Cc: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48921A0C.7020909@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110807310645n3ff6e61j17414433c5aee030@mail.gmail.com>
	 <20080731143905.GF19665@khazad-dum.debian.net>
	 <c4e36d110807311101h4fea377dsb4470c0935bbd419@mail.gmail.com>
	 <48921A0C.7020909@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/31 Jeremy Fitzhardinge <jeremy@goop.org>:
> Zdenek Kabelac wrote:
>> SysRQ+B  doesn't work with right AltGr on my keyboard - but it does
>> work with the left Alt which I'm not normally using (It's somewhat
>> easier to use the right one)
>> Any idea why AltGR+SysRQ+b does not work on T61 ?
>>
>
> You can type them separately: AltGr+SysRq, AltGr+b (holding AltGr across
> the sequence).
>

Ok this sequence does work - so one mystery solved :)

now the remaining part is.


I'll probably try to bisect  rc.sysinit script to check what is the
first command
that breaks the reboot  - but if there is any idea what should I test first.?

Zdenek
