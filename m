Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbXFLPb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbXFLPb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbXFLPbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:31:52 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:40838 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385AbXFLPbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:31:52 -0400
Date: Tue, 12 Jun 2007 17:31:50 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/18] splice: abstract out actor data
Message-Id: <20070612173150.80f6f7e3.dada1@cosmosbay.com>
In-Reply-To: <11816314942637-git-send-email-jens.axboe@oracle.com>
References: <11816314942627-git-send-email-jens.axboe@oracle.com>
	<11816314942637-git-send-email-jens.axboe@oracle.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2007 08:57:57 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:


> +	struct splice_desc sd = {
> +		.total_len = len,
> +		.flags = flags,
> +		.pos = *ppos,
> +	};
> +
> +	sd.file = out;

minor remark, why sd.file is setup differently than other fields ?

(this several times on this patch)
