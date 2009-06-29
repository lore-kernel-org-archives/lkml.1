Return-Path: <linux-kernel-owner+w=401wt.eu-S1758340AbZF2JsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340AbZF2JsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZF2JsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:48:07 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:44010 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbZF2JsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:48:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=F7KugM0Fj7Rh18t8nsClmqgiYD0mPErI1P3nawguoOF1WEPXZ6lXHO657pEZHoN9NI
         vyMi64q//ZGfRkbcrNWtASxHTvpvNb+B7oeqHfNWbREyq6883lsY7Ea36iSm97WsLKBv
         dNFj2sX+Xh7or4oPJ21mBO4C2vaCuWfdIWuTg=
Message-ID: <4A488DD2.1020303@panasas.com>
Date: Mon, 29 Jun 2009 12:48:02 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/62] Remove unnecessary semicolons
References: <cover.1246173664.git.joe@perches.com>
In-Reply-To: <cover.1246173664.git.joe@perches.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2009 07:26 PM, Joe Perches wrote:
> Found by script
> #! /bin/bash
> 
> from=";\s*;\s*\n"
> to=";\n"
> 
> for file in $(grep -rP --include=*.[ch] -li $from *) ; do
> 
>     perl -i -e \
> 	"local $/; while(<>) { s/$from/$to/g; print; }" $file
> 
> done
> 
> Some false positives removed manually
> 

Do we want this in checkpatch.pl?
I do.

Boaz
