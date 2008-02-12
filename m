Return-Path: <linux-kernel-owner+w=401wt.eu-S1761063AbYBLTt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761063AbYBLTt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbYBLTtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:49:47 -0500
Received: from wr-out-0506.google.com ([64.233.184.235]:36539 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbYBLTtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:49:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=w+WOeTM/BYajO5JEDGFDzZZb3Ea39zrOpFRYfIuZsg8EqVYkrBuBITtPsPyb1QtRIB+tYPebzZJnC3HLOS6EhCYSY0Lrqf36iFTY1RH+8tN6fxtof0fsSk/sw7qqRUcqI3eSq/bXXk7zavfg6U5Zoe8Fg4z2rQzihbtdUtc/EKQ=
Message-ID: <47B1F929.1010505@gmail.com>
Date: Tue, 12 Feb 2008 17:53:13 -0200
From: "Carlos R. Mafra" <crmafra@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070914)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Eric Piel <E.A.B.Piel@tudelft.nl>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.25-rc1] Strange regression with CONFIG_HZ_300=y
References: <47B0509E.1040100@gmail.com> <47B15834.6010704@tudelft.nl> <47B1F218.3090407@zytor.com>
In-Reply-To: <47B1F218.3090407@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Eric Piel wrote:
>>>
>>> The laptop is a Vaio VGN-FZ240E, core 2 duo T7250 @ 2.0 GHz and the
>>> kernel is x86_64.
>>
>> Hi, it's great you found out the culprit commit because I was really
>> wondering where this bug was coming from...
>> As a data point, my machine has a core 2 duo @ 1.2GHz and x86_64 arch.
>> Do you also have the tickless option activated? (it could play a role)
>>
> 
> I believe this patch should fix the problem.  Can you please verify?

I've just tested your patch on top of 2.6.25-rc1 and it fixes the
problem!

> Thanks,
> 
>     -hpa

Thank you very much for solving this so fast,
Carlos


