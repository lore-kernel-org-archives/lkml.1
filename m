Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbXJKVnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbXJKVnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbXJKVnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:43:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48716 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbXJKVnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:43:05 -0400
Date: Thu, 11 Oct 2007 14:41:12 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Cc: <Valdis.Kletnieks@vt.edu>, <linux-kernel@vger.kernel.org>
Subject: Re: TPM driver changes to support multiple locality
Message-ID: <20071011144112.0e408dce@laptopd505.fenrus.org>
In-Reply-To: <A3258B497F1C1441AD36A2E8B45FD628CB9AEE@scsmsx412.amr.corp.intel.com>
References: <A3258B497F1C1441AD36A2E8B45FD628C7D657@scsmsx412.amr.corp.intel.com>
	<27383.1192045583@turing-police.cc.vt.edu>
	<A3258B497F1C1441AD36A2E8B45FD628CB9AEE@scsmsx412.amr.corp.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 11:33:35 -0700
"Agarwal, Lomesh" <lomesh.agarwal@intel.com> wrote:

> Below is the patch for TPM driver.
> Comments/suggestions?

please don't top post

> 
> --- pristine-linux-2.6.18/drivers/char/tpm/tpm_tis.c	2006-09-19
> 20:42:06.000000000 -0700
> +++ linux-2.6.18-xen/drivers/char/tpm/tpm_tis.c	2007-10-09
> 15:30:49.000000000 -0700

or send word wrapped patches ....

.. or patches against 2 year old kernels for that matter ;)

>  enum tis_defaults {
>  	TIS_MEM_BASE = 0xFED40000,
> -	TIS_MEM_LEN = 0x5000,
> +	TIS_MEM_LEN = 0x1000,

hmmm/// why
