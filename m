Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbXLLACm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbXLLACm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 19:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbXLLACd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 19:02:33 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:35523 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbXLLACc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 19:02:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=wgXADjRtpwrHSapr9YYtweOyVk3JLdv7ULTrec4bM6xFmMvbc9lNdy2MyU0DYgY9QUawA6OXTa6iodocCawPAIKB5EH5AGhplMBC7NcxYatgF6+TvqweCT5jiy908I1KszKsfinlCjutZANgLPumcPPcIleBtvz51CUA/yeoPhQ=
Message-ID: <475F24C1.2050807@keyaccess.nl>
Date: Wed, 12 Dec 2007 01:01:05 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: nigel@nigel.suspend2.net
CC: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl> <475F2358.6060006@nigel.suspend2.net>
In-Reply-To: <475F2358.6060006@nigel.suspend2.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-12-07 00:55, Nigel Cunningham wrote:

> (AMD 1.8GHz Turion, running at 800MHz. ATI RS480 - Mitac 8350 mobo)
> 
> nigel@home:~/Downloads$ gcc port80.c -o port80
> nigel@home:~/Downloads$ sudo ./port80
> cycles: out 1235, in 1207

Looking good.

> nigel@home:~/Downloads$ gcc -O2 port80.c -o port80
> nigel@home:~/Downloads$ sudo ./port80
> cycles: out 1844674407370794, in 1844674407369408

Obviously not. I suppose this changes with -m32 on the GCC command line? 
(sorry for missing that, I have no 64-bit machines).

Rene.
