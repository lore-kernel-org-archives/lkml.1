Return-Path: <linux-kernel-owner+w=401wt.eu-S1752493AbYE2MtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbYE2MtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 08:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYE2Mss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 08:48:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:57204 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbYE2Msq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 08:48:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=GErHze+g2SPRRgszbIo+CziEZNWTQQlwjZjmdlJ5zzmNWG9psRzzukFPCAdoHbGLnZgvyUPVdbBQakb2mQZfMGueGIj3vKJ9rIuvvw3mYX4QtXL8yVIRAh69lDMxLsvcmD3yVlED7F2UM4VGeRJKvfPsaPO4Y5TQXPmcBv54lU8=
Date: Thu, 29 May 2008 09:51:51 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, jeremy@goop.org, mingo@elte.hu,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 2/2] on_each_cpu(): kill unused 'retry' parameter
Message-ID: <20080529125151.GA25124@Pilar.ictp.trieste.it>
References: <1212051661-12733-1-git-send-email-jens.axboe@oracle.com> <1212051661-12733-3-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212051661-12733-3-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just a naive comment/question:

> -	if (on_each_cpu(ipi_imb, NULL, 1, 1))
> +	if (on_each_cpu(ipi_imb, NULL, 1))

A few weeks ago I though about removing the second argument
from on_each_cpu, which is NULL more or less 70% of the time.

Do you think it is possible?
Have you already thought about it? 

