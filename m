Return-Path: <linux-kernel-owner+w=401wt.eu-S1760491AbYELCpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491AbYELCpt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 22:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbYELCpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 22:45:41 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:20160 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853AbYELCpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 22:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=AnG31E9mpH3hi/POZTHIJ79fmGUI3a7xPrC6J/HBJsv4IQvZWZerAkb3GxhlAw+MMAh9eKpwTVWYs+hWmufsM3wkcJvsZCD+uCAJOwodr9/a+WuA9M9lRA7oFs+crN1K1qRhuvWUTHbPJlcCgtXd5SGb1MfM/hjdrd+ZTuTqRVI=
Date: Mon, 12 May 2008 08:15:22 +0530
From: Rabin Vincent <rabin@rab.in>
To: Manish Katiyar <mkatiyar@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove unused variable "cpu" from arch/x86/xen/setup.c
Message-ID: <20080512024521.GA20281@debian>
References: <ea11fea30805111027x63aa4e44m81407296d16766d8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea11fea30805111027x63aa4e44m81407296d16766d8@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 10:57:12PM +0530, Manish Katiyar wrote:
>  void xen_enable_sysenter(void)
>  {
> -       int cpu = smp_processor_id();
 
This variable is used when building for SMP:

>	if (!boot_cpu_has(X86_FEATURE_SEP) ||
>	    HYPERVISOR_callback_op(CALLBACKOP_register, &sysenter) != 0) {
>		clear_cpu_cap(&cpu_data(cpu), X86_FEATURE_SEP);  <-----
>		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_SEP);

Rabin
