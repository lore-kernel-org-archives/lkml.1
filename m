Return-Path: <linux-kernel-owner+w=401wt.eu-S1751945AbXAVVyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbXAVVyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 16:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbXAVVyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 16:54:39 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:34560 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbXAVVyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 16:54:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=juKPeyjy5BUvXMHk54+XnSXPYFKqIXj7QPuVTm6Se1GT+lPLSTRws0yKSHZMGGw28P0JspJTnziNucz/TDsEHrKG4RVhMbeM4gOfPwFo5qAuPnSAEzNV+Ob/ft8uZDpbHyjYqPMQ8qfTizPLmCwq94vKP5ae36Rk/1q/DpM72hk=
Message-ID: <6bffcb0e0701221354j341e9f07s761c6c049d7196ce@mail.gmail.com>
Date: Mon, 22 Jan 2007 22:54:35 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH -rt] whitespace cleanup for 2.6.20-rc5-rt7
Cc: "Noah Watkins" <nwatkins@ittc.ku.edu>, linux-kernel@vger.kernel.org
In-Reply-To: <20070122195836.GC21277@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11693256381932-git-send-email-nwatkins@ittc.ku.edu>
	 <20070122195836.GC21277@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/01/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Noah Watkins <nwatkins@ittc.ku.edu> wrote:
>
> > fixes trailing whitespace and spaces before tab indents in
> > 2.6.20-rc5-rt7 as reported with: git-apply --whitespace=error-all
>
> thanks. Did you do the patch manually, or do you have a script for that
> perhaps?
>

How about this script?

"d) Ensure that your patch does not add new trailing whitespace.  The below
   script will fix up your patch by stripping off such whitespace.

	#!/bin/sh

	strip1()
	{
		TMP=$(mktemp /tmp/XXXXXX)
		cp "$1" "$TMP"
		sed -e '/^+/s/[ 	]*$//' <"$TMP" >"$1"
		rm "$TMP"
	}

	for i in "$@"
	do
		strip1 "$i"
	done
"
http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
