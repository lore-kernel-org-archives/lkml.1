Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbXKATvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbXKATvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 15:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbXKATvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 15:51:09 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:54428 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbXKATvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 15:51:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=f1qDnjmSH0cWS0DZDSVdBaUS5aFAzI327vYoLk1s4orwNbdd8DHQ3RLU7E6O9pWkelpPN5H6NcGL8i+O6WIMGof+7XQP0dSuCNI1sJeCXpwtw5VbOAz8b49nsQvbVcXEjw1os3zL4jzSA2GqelbNGD9y48+rdxovV6cN2bXFbhM=
Message-ID: <64bb37e0711011251w255746c7x6947f85431d4f4fe@mail.gmail.com>
Date: Thu, 1 Nov 2007 20:51:06 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH] libata ATAPI transfer size cleanups
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071101090733.GA9258@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071101090733.GA9258@havoc.gtf.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/1/07, Jeff Garzik <jeff@garzik.org> wrote:
> +       lo = tf->lbam;
> +       hi = tf->lbam;
> +       ibyte = (hi << 8) | lo;
> +
> +       lo = result_tf->lbam;
> +       hi = result_tf->lbam;

That doesn't look right.
I suspect this was intended:

lo = tf->lbam;
hi = tf->lbah;

Torsten
