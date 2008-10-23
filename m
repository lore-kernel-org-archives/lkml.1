Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbYJWAMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbYJWAMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 20:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbYJWAMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 20:12:16 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:33396 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbYJWAMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 20:12:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=rGw3QuL6BZbgfsF8nnMn+eNbjPB+9yKBvS+vHGJotF36tAgPht+WyTi6d2x//tt9nl
         Pd/Zo2p9CJXiSciMUUC0OXG32q3XtNuFrKEV0zvBYnWvWuZxQH99l+mGfSJyp4wF2e/r
         hAyxDkziEFrJOIJzn1kIu/rkNPj6SDJlmo9dA=
Message-ID: <12c511ca0810221712n665b4c75t5d07c7f4d5e006b2@mail.gmail.com>
Date: Wed, 22 Oct 2008 17:12:14 -0700
From: "Tony Luck" <tony.luck@intel.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH] get rid if __cpuinit and __cpuexit
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <20081022153054.335ce51e@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081022153054.335ce51e@infradead.org>
X-Google-Sender-Auth: 929cd48cc3a61393
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 3:30 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> as discussed briefly at the kernel summit; __cpuinit and __cpuexit are
> causing a ton more complexity than they're worth (just see how many
> section warnings an average build has);

Nice idea ... but on ia64 I actually see *more* section mismatch
warnings with this patch applied :-(

generic_defconfig goes up from 6 to 7
tiger_defconfig rises from 3 to 6

-Tony
