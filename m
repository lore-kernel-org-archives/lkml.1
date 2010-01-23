Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323Ab0AWOne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab0AWOne (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 09:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657Ab0AWOnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 09:43:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:8474 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab0AWOnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 09:43:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=n1dwp5d3PFQDE6OdBmIWhDhVEcCYwgPhtrbjsg+uDKp75xYBzH0aR2eT2mw9e538uE
         Wy69TcCAk5DOgNwBMPaQSdqsYQav7nSZzp/WglGvw2iZ1euWh7l9Jsml+mETUpHrtPdi
         tPIPrY4MVW6m/bVqYDPMGzgYnsi4fsxpstjK4=
Message-ID: <4B5B0B10.2000009@gmail.com>
Date: Sat, 23 Jan 2010 15:43:28 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-9.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Michael H. Warfield" <mhw@wittsend.com>
Subject: Re: linux-next: tty tree build warning
References: <20100120171901.b2e06465.sfr@canb.auug.org.au>	 <b9df5fa11001202022q22c2d81cs5b90f694be37c1f4@mail.gmail.com>	 <20100121230331.GA29796@kroah.com> <b9df5fa11001230453k4a874ebamff02b64f7d6fcd84@mail.gmail.com>
In-Reply-To: <b9df5fa11001230453k4a874ebamff02b64f7d6fcd84@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2010 01:53 PM, Rakib Mullick wrote:
> @@ -309,6 +313,8 @@ module_param_array(io, int, NULL, 0);
>  MODULE_PARM_DESC(io, "I/O ports for IntelliPort Cards");
>  module_param(poll_only, bool, 0);
>  MODULE_PARM_DESC(poll_only, "Do not use card interrupts");
> +module_param_string(ip2, cmd, MAX_CMD_STR, 0);
> +MODULE_PARM_DESC(ip2, "Contains module parameter passed with 'ip2='");

Why not just param_array(int) instead of whole parsing in ip2_setup?

-- 
js
