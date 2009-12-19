Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbZLSRlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbZLSRlZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 12:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbZLSRlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 12:41:23 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:39039 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbZLSRlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 12:41:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=x0trI/7/0SkemfbGCvEE6/e6ysM/AnOd1Dkj6zqFx/hO0TPYV+EpEEJF2GaLpaqAS3
         NUh5pYYu37kGFnpoFHFn0uUmCfv17DEzIZyaPokipyGkCSSb4RKPOJTzILM38Z6QyjBs
         /MRZy+nzYv1nLtzPjJIMU8L5XIvxMS9ZQLXms=
Message-ID: <4B2D1025.1020106@gmail.com>
Date: Sat, 19 Dec 2009 18:40:53 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Bernard Pidoux <bernard.pidoux@upmc.fr>
CC: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Bernard Pidoux <bpidoux@free.fr>
Subject: Re: kernel BUG at kernel/timer.c:951!
References: <4B2CD772.1030106@upmc.fr>
In-Reply-To: <4B2CD772.1030106@upmc.fr>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernard Pidoux wrote, On 12/19/2009 02:38 PM:

> I am experiencing a few kernel panics on my Linux system using 2.6.32 and 2.6.32.1 kernels
> with nosmp. 

Some of these oopses look similarly to those:
http://markmail.org/message/scjov36zm2wf2ytv

How about this patch I sent you for testing?:
http://markmail.org/message/nymi7xyd5c43hyfu

Jarek P.
