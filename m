Return-Path: <linux-kernel-owner+w=401wt.eu-S1752416AbZG0F3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbZG0F3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 01:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZG0F3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 01:29:52 -0400
Received: from mail-qy0-f181.google.com ([209.85.221.181]:37481 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbZG0F3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 01:29:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nG3x46TpBQsG2wk0yhW0CsaGzmLyTon/LTPKSR7SyZa9mevBbFrKP+z6pFCca9bnDy
         bjl8yq5gWNAWgwbSfkfzmW80w+209sRrYyKtQ3jBj5nIILoZ/UWkuep+W7PjP8jLuNmv
         eziZ21Q/b/+JG8AdkulAKK6wIuFhY/zxaYUoQ=
MIME-Version: 1.0
In-Reply-To: <3zAHs5O6maO.A.B5B.IHObKB@chimera>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
	 <3zAHs5O6maO.A.B5B.IHObKB@chimera>
Date: Mon, 27 Jul 2009 13:29:50 +0800
Message-ID: <2375c9f90907262229t2def934emb9340c31d3efdc21@mail.gmail.com>
Subject: Re: [Bug #13838] kernel BUG at include/net/netns/generic.h:41!
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Luca Tettamanti <kronos.it@gmail.com>, netdev@vger.kernel.org,
       herbert@gondor.apana.org.au
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 4:28 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13838
> Subject         : kernel BUG at include/net/netns/generic.h:41!
> Submitter       : Luca Tettamanti <kronos.it@gmail.com>
> Date            : 2009-07-20 15:27 (7 days old)
> References      : http://lkml.org/lkml/2009/7/20/105

Hmm, it looks like that 'pfkey_net_id' is still zero after ipsec_pfkey_init()...

Add Herbert and net-dev into Cc.

Luca, would you mind to provide your .config and the steps to reproduce this?

Thanks.
