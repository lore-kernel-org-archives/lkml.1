Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbXJCFTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbXJCFTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 01:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbXJCFS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 01:18:58 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:20303 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbXJCFS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 01:18:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=O4YSLGKOhss61vr9WQ91atydVJHe/M1ERoKZIibt6qaUYajXXcwRHU0v6ss3Ub37KD4qD0bjKE18g4eNIRwj4I1BfFsmKuSzKBIAE+tHAdEzrPsqYzPiJO0+WOrTInx9s2hY2BDODsTytoJbB4kIW81gOffmo1NAeRGjGjGki/M=
Message-ID: <84144f020710022218x147ffc74y477c0a1be3e60d66@mail.gmail.com>
Date: Wed, 3 Oct 2007 08:18:55 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Neil Romig" <neil@romig.demon.co.uk>
Subject: Re: File corruption when using kernels 2.6.18+
Cc: linux-kernel@vger.kernel.org, hyoshiok@miraclelinux.com
In-Reply-To: <4702B28F.5050404@romig.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46FFC371.9040805@romig.demon.co.uk>
	 <84144f020709300929t6aafd98at23d810d4460e898a@mail.gmail.com>
	 <4702B28F.5050404@romig.demon.co.uk>
X-Google-Sender-Auth: aa26aeb1dc731981
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On 10/3/07, Neil Romig <neil@romig.demon.co.uk> wrote:
> Thanks for your help on this. I have narrowed it down to commit
> "c22ce143d15eb288543fe9873e1c5ac1c01b69a1 x86: cache pollution aware
> __copy_from_user_ll()". This fits with the errors I'm getting, so now I need
> to find out if I can safely ignore this patch, or does it have to be modified?
> This is my first Linux bug in many years of simply using it, so I'm a little
> nervous!

Just to make sure, if you disable CONFIG_X86_INTEL_USERCOPY, the
corruption goes away?
