Return-Path: <linux-kernel-owner+w=401wt.eu-S1761832AbZFLGhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761832AbZFLGhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 02:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbZFLGhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 02:37:25 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:35219 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbZFLGhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 02:37:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=FUwK/8aRacJxspPwPt3lc2t7WbdUGNNX6yned6g+BXeJzXIS3nqLzJ0sQpnRTAptLj
         Qww682hz54LPYTUEb21e28gdGMZAZQ7XSlyWvLET6FQZvGp000+84QywwRtAJQ/TPsAw
         AEdZHZZGhawfQjqKqfUBj9XVj8la0Mm6nWOyA=
MIME-Version: 1.0
In-Reply-To: <b637ec0b0904280609h2583e72ds38867bdf7867a0a2@mail.gmail.com>
References: <b637ec0b0904280609h2583e72ds38867bdf7867a0a2@mail.gmail.com>
Date: Fri, 12 Jun 2009 08:37:25 +0200
Message-ID: <b637ec0b0906112337g73e5aa56l1731beecc0aa14ff@mail.gmail.com>
Subject: Re: OT - Regression: Cisco VPN module hangs 2.6.30-rcX
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
Just un update: the problem is still present in vanilla 2.6.30 . Let's
hope that someone from Cisco takes care of this problem.

Fabio

On Tue, Apr 28, 2009 at 3:09 PM, Fabio Comolli<fabio.comolli@gmail.com> wrote:
> Hi all.
> Please forgive me if this question is considered offtopic on this
> list. I'm not sure where to post it.
>
> Anyway, I have a regression between 2.6.30-rcX and every other version
> I tried with regards to Cisco proprietary cisco_ipsec.ko module.
>
> The module compiles cleanly, loads and the VPN connection is created.
> So far so good. The problem is that as soon as I send packets on the
> tunnel (TCP - UDP doesn't matter, even a nslookup quesry i enough),
> the system hangs without messages on console / logs. Powercycle is
> needed.
>
> Tested with 2.6.30-rc1 and 2.6.30-rc3 with same results. Last good
> version is 2.6.29.2 . Arch is x86 without SMP.
>
> The client version is the latest available to my knowledge,
> vpnclient-linux-x86_64-4.8.02.0030-k9.tar.gz .
>
> I don't know how to debug this, maybe some people from Cisco on this
> list can help.
>
> Thanks and regards,
> Fabio
>
