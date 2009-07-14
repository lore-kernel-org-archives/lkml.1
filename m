Return-Path: <linux-kernel-owner+w=401wt.eu-S1753649AbZGNNj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbZGNNj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 09:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZGNNj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 09:39:58 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:40983 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752406AbZGNNj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 09:39:58 -0400
Subject: Re: kmemleak hexdump proposal
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20090714105709.GB2929@localdomain.by>
References: <20090629201014.GA5414@localdomain.by>
	 <1247566033.28240.46.camel@pc1117.cambridge.arm.com>
	 <20090714103356.GA2929@localdomain.by>
	 <1247567641.28240.51.camel@pc1117.cambridge.arm.com>
	 <20090714105709.GB2929@localdomain.by>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 14 Jul 2009 14:39:41 +0100
Message-Id: <1247578781.28240.92.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2009 13:39:42.0234 (UTC) FILETIME=[8AB017A0:01CA0488]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 13:57 +0300, Sergey Senozhatsky wrote:
[...]
> +/*
> + * Printing of the objects hex dump to the seq file. The number on lines
> + * to be printed is limited to HEX_MAX_LINES to prevent seq file spamming.
> + * The actual number of printed bytes depends on HEX_ROW_SIZE.
> + * It must be called with the object->lock held.
> + */
[...]

The patch looks fine. Could you please add a description and
Signed-off-by line?

Thanks.

-- 
Catalin

