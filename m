Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbYCKT0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbYCKT0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 15:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYCKT0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 15:26:45 -0400
Received: from saeurebad.de ([85.214.36.134]:46116 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbYCKT0o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 15:26:44 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Jan-Simon =?utf-8?Q?M=C3=B6ller?= <dl9pf@gmx.de>
Cc: Len Brown <lenb@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jkosina@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, devzero@web.de,
       linux-kernel@vger.kernel.org, rick@vanrein.org
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
References: <182234194@web.de> <200803101959.47202.dl9pf@gmx.de>
	<200803111323.11524.lenb@kernel.org> <200803111849.53272.dl9pf@gmx.de>
Date: Tue, 11 Mar 2008 20:24:47 +0100
In-Reply-To: <200803111849.53272.dl9pf@gmx.de> ("Jan-Simon =?utf-8?Q?M?=
 =?utf-8?Q?=C3=B6ller=22's?= message
	of "Tue, 11 Mar 2008 18:49:52 +0100")
Message-ID: <873aqxqd1c.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan-Simon,

Jan-Simon Möller <dl9pf@gmx.de> writes:

> Patches V3 with corrected Syntax, tnx hpa !
> Changed also text according to idea from Len.
>
> diff --git a/Documentation/kernel-parameters.txt 
> b/Documentation/kernel-parameters.txt
> index 533e67f..f25da88 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1131,6 +1131,10 @@ and is between 256 and 4096 characters. It is defined 
> in the file
>         memmap=nn[KMG]$ss[KMG]
>                         [KNL,ACPI] Mark specific memory as reserved.
>                         Region of memory to be used, from ss to ss+nn.
> +                       Example: Exclude memory from 0x18690000-0x1869ffff
> +                                memmap=64K$0x18690000
> +                                or
> +                                memmap=0x10000$0x18690000
>
>         meye.*=         [HW] Set MotionEye Camera parameters
>                         See Documentation/video4linux/meye.txt.
>
>
> Signed-off-by: Jan-Simon Moeller <dl9pf@gmx.de>

Would you mind formatting the patch as described in
Documentation/SubmittingPatches?  That probably increases the chance of
getting it merged.

As far as your patch is concerned, I see broken whitespace, a changelog
entry and the signed-off-by is in the wrong place.

	Hannes
