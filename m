Return-Path: <linux-kernel-owner+w=401wt.eu-S1422782AbXBGVSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422782AbXBGVSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 16:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422781AbXBGVSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 16:18:00 -0500
Received: from smtp.osdl.org ([65.172.181.24]:37276 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422778AbXBGVR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 16:17:58 -0500
Date: Wed, 7 Feb 2007 13:17:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sumant Patro <sumantp@lsil.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com,
       sumant.patro@lsi.com
Subject: Re: [PATCH 1/5] scsi: megaraid_sas - stop cmd processing if
 hw_crit_error is set
Message-Id: <20070207131753.1b631421.akpm@linux-foundation.org>
In-Reply-To: <1170798564.10482.12.camel@dumbo>
References: <1170798564.10482.12.camel@dumbo>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Feb 2007 13:49:24 -0800
Sumant Patro <sumantp@lsil.com> wrote:

> +	/* Don't process if we have already declared adapter dead */
> +	if(instance->hw_crit_error)

Preferred kernel coding style is "if (".

> [p1-crit_err.patch  text/x-patch (1.3KB)]

argh.  Please don't send two copies of the patch in the email.  Because the
result applies happily with `patch --dry-run' and then creates a great mess
when you try to apply the patch for real.

