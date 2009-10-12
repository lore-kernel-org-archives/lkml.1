Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbZJLVbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbZJLVbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbZJLVbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:31:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:60453 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbZJLVbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:31:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:cc:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Yd4nsDTNs7N8UOQdhiMNybq0O9UpaVPrHUh8VW2bkZ/M88IuSboeMFfz5nR+fGxaYZ
         G1jaPI0+gXi7nMt+HiRZIRsiQaSEtiENptLoQeM+6v7xyNZc9WubBCRR8LA5JKFFGY0F
         9KLbZzyNyHce8mA0ZY9DFEiTjkX3u4M5WcIWU=
Message-ID: <4AD39FBA.6000509@gmail.com>
Date: Mon, 12 Oct 2009 23:29:30 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-2.8 Thunderbird/3.0b4
MIME-Version: 1.0
CC: rjw@sisk.pl, pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] PM / Hibernate: fix error handling in save_image
References: <1255175505-7756-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1255175505-7756-1-git-send-email-jirislaby@gmail.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2009 01:51 PM, Jiri Slaby wrote:
> +	if (!ret)
>  		printk("\b\b\b\bdone\n");
> +	else
> +		printk("\n");

Only the hell knows why I didn't post a similar fix for load_image...
Will do now.
