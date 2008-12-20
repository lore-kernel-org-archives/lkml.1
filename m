Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbYLTCCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbYLTCCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 21:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbYLTCCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 21:02:38 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:33398 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbYLTCCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 21:02:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GGjZuVPJyZtLv3DjXR2996V9EDaxSr4DQ91UZUscf2htJir3bv0h37c35ZQ17Q/H+O
         ZWXddic6hT6/wC6toZLo87C5WXFEXRaqpKumqhc3kv10HNZInyf8yLgCHxjXrb1QgxC3
         LeZuVZ3nx7obL0AojthCnLX+gut1VzOVmsXXs=
Message-ID: <f19298770812191802g5dfbdbe3hf2ff63f66979fe7c@mail.gmail.com>
Date: Sat, 20 Dec 2008 05:02:34 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: GIT head doesn't seem to want to build on 32bit..
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
In-Reply-To: <20081217113029.GB5027@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081216172859.5bc030b6@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.0812160946410.14014@localhost.localdomain>
	 <20081216181133.2342b49e@lxorguk.ukuu.org.uk>
	 <20081216183817.GA25108@uranus.ravnborg.org>
	 <20081217100727.5cf6248c@lxorguk.ukuu.org.uk>
	 <20081217113029.GB5027@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 14:30, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Wed, Dec 17, 2008 at 10:07:27AM +0000, Alan Cox wrote:
>>
>> > Smells like a kbuild issue.
>> > Please copy me and linux-kbuild@vger.kernel.org on any findings.
>> >
>> > [My 64 bit toolchain is br0ken atm so I could not try to reproduce]
>>
>> Yes I do indeed need to build x86_64 first, then make distclean or
>> mrproper and then 32bit build fails
>
> I will fix my 64 bit build soonish.
> In the meantime could someone do:
>

I can't reproduce this on a 64-bit host no matter what I do.
Alan, could you please provide your 64-bit .config?
Also, I could give Sam ssh to this machine.
