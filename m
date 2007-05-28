Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbXE1GAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbXE1GAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 02:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbXE1GAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 02:00:41 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:55629 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbXE1GAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 02:00:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GglaGyBmTJrMwEHaY9rHKVtZsMraJGKBwHuI7T3b04skUnmVTNaB4xfhFSjTTylFyT9aoQNz+Pf3MfThwIjCY4DNv06FS4yzcdcYhdtC33yMWtoTC3Yc7mnSBQs4KYCelhNSHQaa/wyKfoLujMC+ArolGeerdeEv+m7MHotwte4=
Message-ID: <84144f020705272300r28e7dd71y8328edf9df6ed171@mail.gmail.com>
Date: Mon, 28 May 2007 09:00:39 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "young dave" <hidave.darkstar@gmail.com>
Subject: Re: [patch -mm 1/1] remove useless tolower in isofs
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <a8e1da0705271808w3a6dc453rfb47dd3db100718@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0705271808w3a6dc453rfb47dd3db100718@mail.gmail.com>
X-Google-Sender-Auth: 61758b61bfe3b80e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, young dave <hidave.darkstar@gmail.com> wrote:
> Remove useless tolower in isofs

[snip]

>                 c = tolower(*name++);
> -               hash = partial_name_hash(tolower(c), hash);
> +               hash = partial_name_hash(c, hash);

Looks good to me.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
