Return-Path: <linux-kernel-owner+w=401wt.eu-S1760898AbYDKPaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760898AbYDKPaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760032AbYDKPaC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:30:02 -0400
Received: from rn-out-0910.google.com ([64.233.170.186]:10343 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759960AbYDKPaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:30:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Up1oApay7F5swTRs/Ui0czLYG02TJ3TOHjL2h4e565ldr+7JKyGvQfAuhg4ELi56C7eo3RZVoNWW78YZ/bx8RR74/pV8S81NfBygTN5Op5hBGJZ3HBP7qK44cUYlPfhNUAhn81ojd8ekpTVyC2Nd+J15sPVGD1SGT3U87lGQ0Gs=
Message-ID: <a44ae5cd0804110829j7104ce43q21360078b7291032@mail.gmail.com>
Date: Fri, 11 Apr 2008 11:29:56 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: =?WINDOWS-1252?Q?Re:_2.6.25-rc8-mm2_--_kernel/sched.c:8294:_error:_?= =?WINDOWS-1252?Q?unknown_field_=91read=5Fuint=92_specified_in_initializer?=
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080411135555.GA14342@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0804110648g3256805fob917f31eeff4f6db@mail.gmail.com>
	 <20080411135555.GA14342@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 9:55 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Miles Lane <miles.lane@gmail.com> wrote:
>
>  >   CC      kernel/sched.o
>  > kernel/sched.c:8294: error: unknown field 'read_uint' specified in initializer
>  > kernel/sched.c:8294: warning: initialization makes integer from
>  > pointer without a cast
>  > kernel/sched.c:8295: error: unknown field 'write_uint' specified in initializer
>  > kernel/sched.c:8295: warning: initialization from incompatible pointer type
>
>  cannot reproduce it in sched-devel/for-akpm (which -mm is based off) nor
>  in sched-devel/latest, using your config. Could you check sched-devel
>  via:
>
>   http://people.redhat.com/mingo/sched-devel.git/README

That tree compiled fine after running "make oldconfig".

>  or maybe it's some other sched.c change in -mm? That line is around the
>  control groups code and maybe that got changed in -mm?

I tried a "make mrproper" before compiling the 2.6.25-rc8-mm2 tree and it
still gave the same error.  This seems to be something specific to the latest
MM tree.

    Miles
