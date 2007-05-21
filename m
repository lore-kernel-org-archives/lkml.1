Return-Path: <linux-kernel-owner+w=401wt.eu-S1762263AbXEUSjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762263AbXEUSjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 14:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbXEUSjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 14:39:15 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:39907 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbXEUSjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 14:39:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Mcn05/y+THGbuuc7FS6WD16/pT+qGrQUeWQNN4BrctWGraJHgpBRrChDg+TmKH4XvQL+6JUrE8fmyziEDfNXW+mVWCzZLPJDQBn8DLYmCsq/ls37KnijbDuyzeBFxr8hAe/YML0eqaPj+MNtNoiB85n3Yzr0oTCirmVMiVOeJcU=
Message-ID: <86802c440705211139ofb757fdn9bd012b3e62fca08@mail.gmail.com>
Date: Mon, 21 May 2007 11:39:13 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: [PATCH]serial: make early_uart to use early_prarm instead of console_initcall
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Gerd Hoffmann" <kraxel@redhat.com>, "Andi Kleen" <ak@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <200705211202.59817.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705181900.17101.yinghai.lu@sun.com>
	 <200705211053.34131.bjorn.helgaas@hp.com>
	 <86802c440705211036r19be100pa2d2ed13780f6316@mail.gmail.com>
	 <200705211202.59817.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>   early_param("console", setup_early_console);
>
> and have setup_early_console() ignore everything except "uart"?

console= is used
__setup("console=", console_setup);
early_param doesn't have chance to see it.

YH
