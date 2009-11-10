Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbZKJPO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbZKJPO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:14:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756493AbZKJPO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:14:27 -0500
Received: from [95.166.99.235] ([95.166.99.235]:37846 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756394AbZKJPO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:14:26 -0500
Date: Tue, 10 Nov 2009 16:14:31 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, aaronc@gelato.unsw.edu.au
Subject: Re: [RFC, PATCH] cfq-iosched: remove redundant queuing detection
	code
Message-ID: <20091110151431.GI8742@kernel.dk>
References: <200911101454.57522.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911101454.57522.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10 2009, Corrado Zoccolo wrote:
> The core block layer already has code to detect presence of command
> queuing devices. We convert cfq to use that instead of re-doing the
> computation.

There's is the major difference that the CFQ variant is dynamic and the
block layer one is not. This change came from Aaron some time ago IIRC,
see commit 45333d5. It's a bit of a chicken and egg problem.

-- 
Jens Axboe

