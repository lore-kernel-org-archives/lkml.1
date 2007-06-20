Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbXFTVBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbXFTVBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 17:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbXFTVBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 17:01:45 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:55532 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbXFTVBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 17:01:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NHI3a1lyO0uHH0VPuUdbHqABgt95EUy08ucd14qnDRSUyfI4VcbgjmChnNcNH1w89MqzyhcosrlZ5r06oZnHQF+TWORNmJ75L8LlIk9xvpjxMOHnyXDhfqIKHp4Tn9Ufig7H42uMCrvN2AQHJV2nL1wTxkCrHCSyfnJtm+KGW04=
Message-ID: <9a8748490706201401m36b1e917g5a600951d48e4cf8@mail.gmail.com>
Date: Wed, 20 Jun 2007 23:01:44 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] bracing the loop in kernel/softirq.c
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070620175737.GA6523@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070620175737.GA6523@cvg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/06/07, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> This trivial patch adds braces over a one-line
> loop. That makes code...well... little bit
> convenient for (possible) further modifications.
>
That's generally not done.

It's even in Documentation/CodingStyle :

"
Do not unnecessarily use braces where a single statement will do.

if (condition)
        action();
"

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
