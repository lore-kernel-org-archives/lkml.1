Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbYKQRIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbYKQRIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYKQRII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:08:08 -0500
Received: from gw.goop.org ([64.81.55.164]:59097 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbYKQRIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:08:07 -0500
Message-ID: <4921A4F3.1030309@goop.org>
Date: Mon, 17 Nov 2008 09:08:03 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <htejun@gmail.com>, Arjan van de Ven <arjan@infradead.org>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Fix kunmap() argument in sg_miter_stop
References: <20081115123916.0d83a89e@infradead.org> <491FACC3.1050202@gmail.com> <20081117081117.GD26778@kernel.dk> <20081117082201.GB24603@elte.hu> <20081117083022.GE26778@kernel.dk> <20081117085046.GE28786@elte.hu> <20081117085807.GF26778@kernel.dk> <20081117093425.GG26778@kernel.dk> <20081117094147.GJ28786@elte.hu> <20081117094551.GI26778@kernel.dk> <20081117111350.GJ26778@kernel.dk>
In-Reply-To: <20081117111350.GJ26778@kernel.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> One exception is a real bug that this turned up. The XEN balloon driver
> passes the virt address into kunmap() as well, so that part should go in
> for 2.6.28. I've CC'ed Jeremy.
>   

Oops.  Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

    J
