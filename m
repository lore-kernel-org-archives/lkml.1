Return-Path: <linux-kernel-owner+w=401wt.eu-S1161186AbXDYOqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161186AbXDYOqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 10:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161475AbXDYOqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 10:46:54 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:24581 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161186AbXDYOqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 10:46:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eb69mbqN3ySRj9d4/FpunrODaLNUMR0wYXn3J1988S8rFld6LwmZBGasdVGTQVPJOyArfREDyv1rJFUvnojGxFnrM2paOrT+UCr9xH9q6ugNuk15qie7wclc8M6jY6GebMGtMklrlPGtioybIphp+qhr+rt5PYpE/WIWAAY2qwE=
Message-ID: <f9eabcda0704250746j26c67d03wc971c4ca32312ca1@mail.gmail.com>
Date: Wed, 25 Apr 2007 11:46:48 -0300
From: "Miguel Freitas" <mfreitas@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Advice on debuging the fork syscall hanging forever
In-Reply-To: <f9eabcda0704250721k20ba8a6bl50b8b0494caf5531@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f9eabcda0704250721k20ba8a6bl50b8b0494caf5531@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/07, Miguel Freitas <mfreitas@gmail.com> wrote:
> (...)
> 0x00002b2e77d6d5b6 <fork+134>:  mov    $0x38,%eax
> 0x00002b2e77d6d5bb <fork+139>:  syscall
> 0x00002b2e77d6d5bd <fork+141>:  cmp    $0xfffffffffffff000,%rax
>
> (...)
>
> (gdb) info reg
> rax            0xfffffffffffffdff       -513

hey, could it be that this -513 is actually -ERESTARTNOINTR?
which, btw, is said to "Should never be seen by user programs" in
include/linux/errno.h?

is it leaking? ;-)

Miguel
