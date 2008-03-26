Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbYCZPCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbYCZPCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbYCZPCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:02:05 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:23159 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbYCZPCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:02:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rirJ0rKGj9SRKe6cRK9r9QLwt0lyd0l3x8jC/dZAe85yluyPCju2ny1quS1zJx989lVGPubiWWJrv1mH+mm000OGCmYZxiadwuqTZhPE0rImijhBfzdC786PsSWOdYy3+2HuwqptpxyxyGheEJJ9yjkIyKIC2bn+i8pi60WppOw=
Message-ID: <8bd0f97a0803260802u4fb4d83aq6da1268e0ce7fa0@mail.gmail.com>
Date: Wed, 26 Mar 2008 11:02:02 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] Blackfin Watchdog Driver: split platform device/driver registering from actual watchdog device/driver registering so we can cleanly load/unload
Cc: "Bryan Wu" <cooloney@kernel.org>, wim@iguana.be,
       linux-kernel@vger.kernel.org
In-Reply-To: <47EA2D32.1020109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206581401-26046-1-git-send-email-cooloney@kernel.org>
	 <47EA2D32.1020109@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/3/26 Jiri Slaby <jirislaby@gmail.com>:
> On 03/27/2008 02:30 AM, Bryan Wu wrote:
>  > From: Mike Frysinger <vapier.adi@gmail.com>
>  > +#define pr_devinit(fmt, args...) ({ static const __devinitdata char __fmt[] = fmt; printk(__fmt, ## args); })
>
>  Ah and here. __devinitconst

that define doesnt exist for me so it'd be hard to use it ... where
are you finding this ?
-mike
