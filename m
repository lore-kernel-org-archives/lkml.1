Return-Path: <linux-kernel-owner+w=401wt.eu-S1760016AbYC0TiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016AbYC0TiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 15:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758975AbYC0Th4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 15:37:56 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:38309 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758269AbYC0Thz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 15:37:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PZXUZySKT9cpdc15TYp2oZBRUhL9Gfj2vHOmrf3dglMO7I3sWylw66Tt+7NCWZvaUz5tzLxPdvFPCZ7nm/ewy/NGCAK4Qa7X+V9GR4GCvI//I6OItQS+1UVojcDvjEfI/zlGHzmYh92t6FvJcjnY5fJIADT+/jOrucTlZzn1Ts8=
Message-ID: <e9c3a7c20803271237x1b2c3a2ci6837c5e2d5288c95@mail.gmail.com>
Date: Thu, 27 Mar 2008 12:37:52 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Zhang Wei" <wei.zhang@freescale.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] fsldma: The MPC8377MDS board device tree node for fsldma driver
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Kumar Gala" <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org
In-Reply-To: <1206517356-11209-2-git-send-email-wei.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206517356-11209-1-git-send-email-wei.zhang@freescale.com>
	 <1206517356-11209-2-git-send-email-wei.zhang@freescale.com>
X-Google-Sender-Auth: 93205256cb903a71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 12:42 AM, Zhang Wei <wei.zhang@freescale.com> wrote:
> The fsldma driver is tested on MPC8377MDS board.
>  The patch adds fsldma driver support into MPC8377MDS device tree.
>
>  Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
>  ---
>   arch/powerpc/boot/dts/mpc8377_mds.dts |   27 +++++++++++++++++++++++++++
>   1 files changed, 27 insertions(+), 0 deletions(-)

I think this patch should probably go through the powerpc tree, or
-mm.  I'll pick up the ones that touch either drivers/dma or
crypto/async_tx.

--
Dan
