Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbYJTXOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbYJTXOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYJTXOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:14:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:34167 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbYJTXOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:14:10 -0400
Subject: Re: [PATCH] fix WARN() for PPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       johannes@sipsolutions.net, davem@davemloft.net
In-Reply-To: <20081020145056.24d84992@infradead.org>
References: <20081020145056.24d84992@infradead.org>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 10:13:47 +1100
Message-Id: <1224544427.7654.184.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-20 at 14:50 -0700, Arjan van de Ven wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Mon, 20 Oct 2008 14:41:03 -0700
> Subject: [PATCH] fix WARN() for PPC
> 
> powerpc doesn't use the generic WARN_ON infrastructure. The newly introduced WARN()
> as a result didn't print the message, this patch adds the printk for this specific case.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Thanks, will apply.

Cheers,
Ben.


