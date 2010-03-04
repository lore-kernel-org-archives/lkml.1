Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab0CDKIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 05:08:11 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42966 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab0CDKII convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 05:08:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=twCoSxlOJcrI52Pr5DtbWoTlvp7rpkcI54lZ5ipQwPu4W5isehldzymkZi5gP1AwM2
         UqSCnZB+v7XURPfLUfxYBuBU1VqFnEPgQnURqZYuMDhWuxqbCG/jCSig5GLW3q9OP2Fk
         ae0Ozo71aX7L2feapS9d/9II+9ndOMTC9WgeM=
MIME-Version: 1.0
In-Reply-To: <7f9bf5711003020755p653a0b8cq707e9b1e12b44c98@mail.gmail.com>
References: <4B8C56F0.5090700@gmail.com>
	 <2375c9f91003011924k43f03649y5b4df405d6247a79@mail.gmail.com>
	 <5e9821061003012150y15e543cdkf6f23c3a7a47e4a3@mail.gmail.com>
	 <20100302153651.GC4014@hack>
	 <7f9bf5711003020755p653a0b8cq707e9b1e12b44c98@mail.gmail.com>
Date: Thu, 4 Mar 2010 18:08:07 +0800
Message-ID: <2375c9f91003040208g1c66f1eft6c2c1044ed995c4e@mail.gmail.com>
Subject: Re: Notifier chains bug ?
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Atis Elsts <atis.elsts@gmail.com>
Cc: Oleg Kutkov <elenbert@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 2, 2010 at 11:55 PM, Atis Elsts <atis.elsts@gmail.com> wrote:
> I'm no expert, but IMHO for handling IP address changes you should use
> function register_inetaddr_notifier() to register you callback and
> then wait for  NETDEV_UP and NETDEV_DOWN events.
>

Oh, I think you are right.

Btw, please don't drop Cc's.

Thanks.
