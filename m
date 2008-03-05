Return-Path: <linux-kernel-owner+w=401wt.eu-S1763692AbYCEG3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763692AbYCEG3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 01:29:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760280AbYCEG22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 01:28:28 -0500
Received: from gv-out-0910.google.com ([216.239.58.186]:8630 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759881AbYCEG20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 01:28:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VZyu23lWoC44BC/KvRHeWUsHX2Xpla0LJiALdApKDXSQGZpHrpd2Zvq16p3WHZw0LgE6X/UHGNHu8DrYadMB+pPyicZmLthyNIbxDm5xwZKMzO3Lz2JhAK0WtpapqctPMtyx/lQP3fPQi2DJxkSstRQcyATNjSsWx50H7BwK3wI=
Subject: Re: [PATCH 3/11] /drivers/char/ip2/ip2main.c replaced
	init_module&cleanup_module with module_init&module_exit
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jon Schindler <jkschind@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <47CE3466.5050306@watson.wustl.edu>
References: <47CE3466.5050306@watson.wustl.edu>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 22:28:18 -0800
Message-Id: <1204698498.17484.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-04 at 23:49 -0600, Jon Schindler wrote:
> Replaced init_module and cleanup_module with static functions and module_init/module_exit.
> 

trivial comments

>  #ifdef MODULE
> -int
> -init_module(void)
> +static int __init
> +ip2_init_module(void)
>  {

+static int __init ip2_init_module(void)

> ****************************************************************/
>  #ifdef MODULE
> -void
> -cleanup_module(void)
> +void __exit
> +ip2_cleanup_module(void)
>  {

+void __exit ip2_cleanup_module(void)

Cheers,

Harvey

