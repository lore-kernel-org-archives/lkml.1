Return-Path: <linux-kernel-owner+w=401wt.eu-S1752091AbYAHT7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbYAHT7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbYAHT7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:59:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:40745 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbYAHT7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:59:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=ms0wMxH1K+MySkeGmn9Ucc1gb0iyqUXbXhl1yoPnBgxi5avAWXcGvtc1KpGINulUFsrpyBHYPgFO2ZDKFJRu8h9fRHgSAWy2Jw5KZDVGf2XsvC5il/0N6ZC0Y229MNAZMLsQwrROTfCxv3tvf95xIbec6XvjLGZ3NZil5bL2BOE=
Date: Tue, 8 Jan 2008 22:59:33 +0300
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: Re: [PATCH 3/5] x86: coding style fixes in arch/x86/ia32/ia32_aout.c
Message-ID: <20080108195933.GB4627@martell.zuzino.mipt.ru>
References: <20080108203233.01bb5c7f@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108203233.01bb5c7f@paolo-desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -		if ((jiffies-error_time) > 5*HZ)
> -		{
> -			printk(KERN_WARNING 
> +		if ((jiffies-error_time) > 5*HZ) {

Should we expect second wave of this crap when you will suddenly realize
that it would be even nicer to write:

	if (jiffies - error_time > 5 * HZ) {

	Alexey "?" Dobriyan
