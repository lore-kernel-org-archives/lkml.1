Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbXCPPIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbXCPPIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 11:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbXCPPIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 11:08:04 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:46082 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbXCPPID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 11:08:03 -0400
Date: Fri, 16 Mar 2007 16:06:22 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 08/15] KVM: Add method to check for backwards-compatible API extensions
Message-ID: <20070316150622.GC8525@osiris.boeblingen.de.ibm.com>
References: <11736212072915-git-send-email-avi@qumranet.com> <1173621207256-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173621207256-git-send-email-avi@qumranet.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
> index 747966e..376538c 100644
> --- a/drivers/kvm/kvm_main.c
> +++ b/drivers/kvm/kvm_main.c
> @@ -2416,6 +2416,12 @@ static long kvm_dev_ioctl(struct file *filp,
>  		r = 0;
>  		break;
>  	}
> +	case KVM_CHECK_EXTENSION:
> +		/*
> +		 * No extensions defined at present.
> +		 */
> +		r = 0;
> +		break;
>  	default:

What exactly is this good for?
