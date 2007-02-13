Return-Path: <linux-kernel-owner+w=401wt.eu-S1030655AbXBMGhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030655AbXBMGhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 01:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161021AbXBMGhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 01:37:13 -0500
Received: from smtpq3.groni1.gr.home.nl ([213.51.130.202]:57259 "EHLO
	smtpq3.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030655AbXBMGhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 01:37:11 -0500
Message-ID: <45D15C7D.1050400@gmail.com>
Date: Tue, 13 Feb 2007 07:36:45 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86 for review II] [13/39] i386: CONFIG_PHYSICAL_ALIGN
 limited to 4M?
References: <20070212837.963446000@suse.de> <20070212073800.3D44313DD5@wotan.suse.de>
In-Reply-To: <20070212073800.3D44313DD5@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2007 08:38 AM, Andi Kleen wrote:

> From: Rene Herman <rene.herman@gmail.com>

[ ... ]

> --- linux.orig/arch/i386/Kconfig
> +++ linux/arch/i386/Kconfig
> @@ -843,7 +843,7 @@ config RELOCATABLE
>  config PHYSICAL_ALIGN
>  	hex "Alignment value to which kernel should be aligned"
>  	default "0x100000"
> -	range 0x2000 0x400000
> +	range 0x2000 0x1000000
>  	help
>  	  This value puts the alignment restrictions on physical address
>   	  where kernel is loaded and run from. Kernel is compiled for an

Okay I guess, but in reply to this, Vivek Goyal pointed out a patch of 
his restoring CONFIG_PHYSICAL_START that was already in -mm instead 
since it seems Xen also wanted it. That does also match what I wanted it 
for better:

http://lkml.org/lkml/2007/1/2/376

Rene.

