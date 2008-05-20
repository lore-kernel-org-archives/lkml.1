Return-Path: <linux-kernel-owner+w=401wt.eu-S1765403AbYETJ5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765403AbYETJ5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764400AbYETJxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:53:54 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:35703 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761216AbYETJxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:53:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=Ro8rmr7E5b5i1m4iCPC9jsemUIWSSljx2rSsegzx965aMSNJSFaCyYwwyhhF5L4oj9igH81DFCfRo4sqd5k6Ddni/EyZMkR07NMGpZT9kRD9qpK2iOUFZIC+qMiX2fL0NPIZQvlp3DnA4Ge4grKVeLdmHP9m1aK+Eb9CWm/0UII=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 15/15] rfkill: document rw rfkill switches and clarify input subsystem interactions
Date: Tue, 20 May 2008 12:09:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Dmitry Torokhov <dtor@mail.ru>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <1211136485-19878-16-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1211136485-19878-16-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805201209.08986.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +You should:
>  	- rfkill_allocate()
> -	- input_allocate_polled_device()
> +	- modify rfkill fields (flags, name)
> +	- modify state to the current hardware state (THIS IS THE ONLY TIME
> +	  YOU CAN ACCESS state DIRECTLY)
>  	- rfkill_register()
> -	- input_register_polled_device()

Wasn't it the plan to send the current hardware state as rfkill registration argument,
so we can force drivers to send a valid state to rfkill?

Ivo
