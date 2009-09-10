Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbZIJT6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbZIJT6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 15:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbZIJT6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 15:58:00 -0400
Received: from fifo99.com ([67.223.236.141]:33707 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846AbZIJT57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 15:57:59 -0400
Subject: Re: [PATCH] tpm_tis: TPM_STS_DATA_EXPECT workaround
From: Daniel Walker <dwalker@fifo99.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Andy Isaacson <adi@hexapodia.org>, jmorris@namei.org, len.brown@intel.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andy Isaacson <adi@vmware.com>,
       linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
       dds@google.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>, seiji.munetoh@gmail.com
In-Reply-To: <1252612471.4837.107.camel@blackbox>
References: <1246410255-6839-1-git-send-email-adi@vmware.com>
	 <1246410255-6839-6-git-send-email-adi@vmware.com>
	 <20090701110136.576a1d14@lxorguk.ukuu.org.uk>
	 <1246455920.9140.28.camel@blackbox>  <20090720182732.GL6370@hexapodia.org>
	 <1252609714.4837.87.camel@blackbox>  <1252612471.4837.107.camel@blackbox>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 12:58:29 -0700
Message-Id: <1252612709.30578.219.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 16:54 -0300, Rajiv Andrade wrote:

> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> ---
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index aec1931..c9990db 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -257,6 +257,10 @@ out:
>  	return size;
>  }
>  
> +static int itpm = 0;

This patch has some checkpatch issues .. Could you run it
through ./script/checkpatch.pl and fix the issues that get reported?

Daniel

