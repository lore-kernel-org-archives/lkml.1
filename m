Return-Path: <linux-kernel-owner+w=401wt.eu-S1752019AbZG1Iau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbZG1Iau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 04:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbZG1Iat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 04:30:49 -0400
Received: from mail-bw0-f221.google.com ([209.85.218.221]:35192 "EHLO
	mail-bw0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbZG1Iar convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 04:30:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kncVJsnQQumHyGDhtRAgZF46sWCoZlFz9vWcYCTSJ1Tlefxfrd8EBCTZoGuCvIbV9I
         OoagTyXDbt5zRIeWBGUcqVEpasgXjdELRYcSminA6MJs4gYWCJI9cZemdI3nOdEN08VB
         II6R3DzRTB5CELDDDW5tsvtA5eNiTfv/dNvrg=
MIME-Version: 1.0
In-Reply-To: <2375c9f90907262229t2def934emb9340c31d3efdc21@mail.gmail.com>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
	 <3zAHs5O6maO.A.B5B.IHObKB@chimera>
	 <2375c9f90907262229t2def934emb9340c31d3efdc21@mail.gmail.com>
Date: Tue, 28 Jul 2009 10:30:46 +0200
Message-ID: <68676e00907280130tbbf5672x83182641b0c977b3@mail.gmail.com>
Subject: Re: [Bug #13838] kernel BUG at include/net/netns/generic.h:41!
From: Luca Tettamanti <kronos.it@gmail.com>
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, herbert@gondor.apana.org.au,
       Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 7:29 AM, Américo Wang<xiyou.wangcong@gmail.com> wrote:
> On Mon, Jul 27, 2009 at 4:28 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.30.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13838
>> Subject         : kernel BUG at include/net/netns/generic.h:41!
>> Submitter       : Luca Tettamanti <kronos.it@gmail.com>
>> Date            : 2009-07-20 15:27 (7 days old)
>> References      : http://lkml.org/lkml/2009/7/20/105
>
> Hmm, it looks like that 'pfkey_net_id' is still zero after ipsec_pfkey_init()...
>
> Add Herbert and net-dev into Cc.
>
> Luca, would you mind to provide your .config and the steps to reproduce this?

I cannot reproduce it anymore with the current git kernel. The BUG was
triggered by racoon at startup.
Should I go back to an older kernel to investigate or can we consider
it "fixed"?

Luca
