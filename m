Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbYJUW24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbYJUW24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 18:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYJUW2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 18:28:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:58892 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbYJUW2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 18:28:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YyuIR5RPcTP2Tl/iQFP7XAO2FyVKEYmxOHPTHAkmv6Fmii0vUCe2Vw+MUaAjpbgE6P
         vXO/zRb2qEXsSllyu6nrZ8SG/vnA0N7VYiErtD5K5tXc1COF+6wN12rlVJmchP2Vxkk7
         lMAozxG/y7VU73z6Hka1pAm48cncR2NEK/cVI=
Message-ID: <c6740f810810211528g641b3224j3a70ee4b56942bb9@mail.gmail.com>
Date: Wed, 22 Oct 2008 00:28:40 +0200
From: "Philip Stark" <heller.barde@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27 seems to break something with DSL
Cc: netdev@vger.kernel.org
In-Reply-To: <20081020101241.456963cd@doriath.conectiva>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c6740f810810110553q75478033ub984651d5509199b@mail.gmail.com>
	 <20081020101241.456963cd@doriath.conectiva>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was just going to say that Bug Nr. 11721 on bugzilla.kernel.org is
exactly my problem and is in fact resolved with the
solution/workaround presented there.

Thanks for your time
Philip Stark

2008/10/20 Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>:
<snip>
> | it seems to  be related to the packet  size because ping only seems to
> | work because it uses small packets. if i increase the ping size up to
> | 1000 bytes, it fails as well. (while it does work on 2.6.26)
>
>  If you haven't solved this issue yet you could try:
>
> # echo 0 > /proc/sys/net/ipv4/tcp_timestamps
>
>  We (Mandriva) have had some reports of this issue and it seems that
> some broken routers can drop packages because of the timestamp (that's
> what our local network guy has said). Disabling timestamps make it work
> again.
>
> --
> Luiz Fernando N. Capitulino
>
