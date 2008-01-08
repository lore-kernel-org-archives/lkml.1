Return-Path: <linux-kernel-owner+w=401wt.eu-S1758744AbYAHNvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744AbYAHNvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 08:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbYAHNvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 08:51:40 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:16599 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYAHNvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 08:51:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RzFv6iUAkvP/YHFg2gDY6QOSYt7QDohfZR+RpdUCVoOFw85a7O77J0KWAvQyZ4S8+sN09JoOnEDLvUv5KX1MHhEbEBNBZ9DJywWnLF46QGxRH3HC6BxOtegJaGw7cW373dK8HQBmcZYfz/Rfa30ptPKM2tH/gpIcTX9P5rSnFTA=
Message-ID: <5eeb9ad90801080551n562b9f15o27b495495a452c22@mail.gmail.com>
Date: Tue, 8 Jan 2008 14:51:37 +0100
From: DM <dm.n9107@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [patch 2/2] track and print last unloaded module in the oops trace
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu
In-Reply-To: <20080106151946.50c3d8cc@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080106151946.50c3d8cc@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 7, 2008 12:19 AM, Arjan van de Ven <arjan@infradead.org> wrote:
[...]
> This patch tracks the last unloaded module, and prints this as part of the
> module list in the oops trace.
>
[...]
>        }
> +       /* Store the name of the last unloaded module for diagnostic purposes */
> +       sprintf(last_unloaded_module, mod->name);
>        free_module(mod);
>

Why use sprintf? If a module name contains the % character we could
overflow the buffer. Or is module-unloading root-only and we don't
care?

Best regards,
dm.n9107
