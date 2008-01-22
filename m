Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbYAVNVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbYAVNVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 08:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbYAVNUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 08:20:51 -0500
Received: from hs-out-0708.google.com ([64.233.178.249]:22627 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751947AbYAVNUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 08:20:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VlGoIAjxWNmdo1RteEaQ9O1iqSrg8ur1FhnFgtbNC2JCveU/+qS6GkLzeTJVLVKX/bo1r/OwTIz1e/t+Soa1fc1S0fapZTXlNPH00aeDUIkHb8UY2k/oYwxpwWQXZnjMwFEAVjmimsYsiSfzR7ebzSQICbfdKYh9fAuupNh61Zo=
Message-ID: <4d8e3fd30801220520p14dbf5aau874d1df86415359a@mail.gmail.com>
Date: Tue, 22 Jan 2008 14:20:48 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: apw@shadowen.org, "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: add filename in the summary
In-Reply-To: <20080114232339.2c018647@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080114232339.2c018647@paolo-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 14, 2008 11:23 PM, Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
> Add a filename option (default to 0)
> in order to get the following summary output:
> ./scripts/checkpatch.pl --filename --file ./arch/sparc/kernel/apc.c
> ...
> ...
> ...
> ./arch/sparc/kernel/apc.c --> total: 18 errors, 3 warnings, 186 lines checked
> ---
>
> Andy,
> I wonder why checkpatch doesn't show all the command line options.
> At the moment, it only prints:
> options: -q           => quiet
>         --no-tree    => run without a kernel tree
>         --terse      => one line per report
>         --emacs      => emacs compile window format
>         --file       => check a source file
>         --strict     => enable more subjective tests
>         --root       => path to the kernel tree root
>
> but I see a lot more options:
>         q|quiet
>         tree
>         signoff
>         patch
>         test-type
>         emacs
>         terse
>         file
>         subjective
>         strict
>         root=s
>         summary
>         mailback
>
[patch snipped]

Hi Andy,
do you plan to document all the command line options that checkpatch
is currently accepting?

Thanks.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
