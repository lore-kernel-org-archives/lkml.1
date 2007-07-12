Return-Path: <linux-kernel-owner+w=401wt.eu-S934846AbXGLBbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934846AbXGLBbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 21:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760197AbXGLBbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 21:31:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:10817 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761267AbXGLBbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 21:31:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q5dXPAoXWE/hJ7d9PJxDEi9BHmQESAEo/l6rLpzk2jec+cTvCa37sgrTAMRRXEwULttaWRqZBFvIQocTfVn+7fFdk/cLq1OUJttCa93LjMF1FRnJzEvRI2kyF6alfVTWGt3l/wAZCdcUdudkMN+Y/j97RARiiSKhEB2f5YlXJCI=
Message-ID: <d3dac270707111831v508e7c56w966df5bc2e7f855e@mail.gmail.com>
Date: Wed, 11 Jul 2007 18:31:10 -0700
From: "Max Alekseyev" <maxale@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22 booting hangs after "INIT: version 2.86 booting"
In-Reply-To: <d3dac270707111413j42ac7a0eif032636a9018df66@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d3dac270707111413j42ac7a0eif032636a9018df66@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It happened that this weird behavior was caused by gcc-4.2 compiler.
After recompiling the kernel with gcc-4.1 all troubles have gone.

Max

On 7/11/07, Max Alekseyev <maxale@gmail.com> wrote:
> Hello!
>
> I have trouble with booting linux kernel 2.6.22 from kernel.org on my
> AMD dual-Opteron 250 system.
> The booting stops right after printing line "INIT: version 2.86
> booting". Nothing happens after that, but it is not a hardware hang as
> keyboard leds respond to pressing Caps/Num lock keys.
>
> If I boot with init=/bin/sh parameter I successfully get into the
> shell but attempts to run scripts from /etc/rcS.d/ all end up with
> Segmentation faults, e.g.:
>
> # sh -x /etc/rcS.d/S01glibc.sh
> ++ uname -s
> Segmentation fault
>
> I am not sure where these segfaults happen as running programs like
> 'uname' directly from the shell works OK.
>
> The 2.6.22 configuration is derived from the working 2.6.21 one. The
> kernel 2.6.21 boots on the very same system without any problems.
> Any suggestions?
>
> Thanks,
> Max
>
