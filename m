Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbXJVSQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbXJVSQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbXJVSMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:12:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:9687 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbXJVSM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=C1JJrR0+saMsk5aloTvIoMfzxYEhbzQ1QUKBZ++UX2GB2Nn9nmW7R/tjGiBAqiBsCBlZ1OkICYrKjnFXLxj6ub48M461srnLKpXgiIfI0gG+fmDBLfHJzYIVwm4RrPlTuyA5oEWSo2adRzRtV5mrrCA1kjcjy7TSopVaMjg5E1Q=
Message-ID: <2c0942db0710221112g7c7d99caj7feb0c2ac5de17e7@mail.gmail.com>
Date: Mon, 22 Oct 2007 11:12:23 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Roel Kluin" <12o3l@tiscali.nl>
Subject: Re: [PATCH] return hidden bug
Cc: "Rik van Riel" <riel@redhat.com>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <471CE453.5050208@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <471BF741.2020501@tiscali.nl>
	 <20071021214209.1a7567d7@bree.surriel.com>
	 <2c0942db0710220942he5e9199i2e327df3c5676a6a@mail.gmail.com>
	 <471CE453.5050208@tiscali.nl>
X-Google-Sender-Auth: 0bef8fd3b7ac84e6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/07, Roel Kluin <12o3l@tiscali.nl> wrote:
> Ray Lee wrote:
>
> > I'm sorry, perhaps I poured myself a cup of stupid this morning, but
> > isn't the above patch effectively introducing a BUG where none could
> > be reached before? In other words, for the patch to have zero
> > behavioral change, wouldn't it have to remove the BUG() altogether?
>
> True, but obviously not intended. I think the intention was to expose this bug.

Arguing intentions is very dangerous. I've written code like that
where the intention is to make it simple to turn a printk into a full
bug and back and forth during development. At the end of the day, the
fact remains that you're changing behavior.

Let me turn this around. Do you have an alpha and have you tried out
your patch? If not, then I'd suggest turning it into a WARN_ON(1)
instead, as in this specific case you're risking turning what was a
working system into one that doesn't.
