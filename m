Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZCYVys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZCYVys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZCYVyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:54:39 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:22691 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZCYVyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ROLjjdQUimyIm+vjDpvG0qwO19IXkMdWeI6V7tXm9lzyLgUELwgzAoQu/JA+fK52Xk
         4eGzz/rEHfV177AlgbPuTCdaof4yPBJmPfMz7zKQjQzR5eiMtMv9MmF1HEnZsbzt1WzS
         FFPzH5/PgD+yVQ4Y0W6pa5Yq+dlQUph36E/rE=
Message-ID: <49CAA819.2010102@gmail.com>
Date: Wed, 25 Mar 2009 22:54:33 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Evgeniy Ivanov <lolkaantimat@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux and FPU
References: <200903251409.27827.lolkaantimat@gmail.com>
In-Reply-To: <200903251409.27827.lolkaantimat@gmail.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2009 12:09 PM, Evgeniy Ivanov wrote:
> Hello,
> 
> Can somebody point me to some general places, where I can look on how FPU 
> support is implemented. I understand that there is not one place, where things 
> done, the only I know, that there should be places for detecting FPU hardware 
> and places with assembly routines for pushing around floating point registers, 

I think you want to start with
arch/x86/kernel/i387.c
arch/x86/math-emu/

> assembly/C-hybrid code for handling floating point exceptions.

and arch/x86/kernel/traps.c

