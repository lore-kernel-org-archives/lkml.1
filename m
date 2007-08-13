Return-Path: <linux-kernel-owner+w=401wt.eu-S1032406AbXHMRUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032406AbXHMRUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S947059AbXHMRJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:09:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:16268 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031858AbXHMRJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:09:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qliZcUrt95/51XBduODNhQxlj58h1ZWsI+GvxBB2CcLAbrNFbnsYGojcw7xtID4UFCu1wPYLdIKvysnP/sTPyY31fxlff9p6Olq0pGws3Fun/VObhV3ceaVTmCPYeFwKbjUJdMqubVgrL11QGC9R/Z2mhDKlMKOr9vo3IhVPG+k=
Message-ID: <2c0942db0708131009y6f1c4cc4n59d8b36943643955@mail.gmail.com>
Date: Mon, 13 Aug 2007 10:09:08 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Joe Perches" <joe@perches.com>
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
In-Reply-To: <1186984174.10249.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186984174.10249.7.camel@localhost>
X-Google-Sender-Auth: efb5daf09dfdebc6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/07, Joe Perches <joe@perches.com> wrote:
> I grew weary of looking up the appropriate
> maintainer email address(es) to CC: for a patch.
>
> I added flags to the MAINTAINERS file
>
> F:      file pattern
>
> for each maintained block and a script to parse
> the modified blocks for maintainer and list
> email addresses.

Why not parse git annotate or blame instead (other than it's freakin'
slow)? Using the repository history has the added benefit of telling
you a lot more fine-grained detail about who may want to know about
your patch.
