Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbZA1R6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbZA1R6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 12:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbZA1R5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 12:57:53 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:37080 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752370AbZA1R5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 12:57:52 -0500
Date: Wed, 28 Jan 2009 11:45:28 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: David Miller <davem@davemloft.net>
cc: tj@kernel.org, rusty@rustcorp.com.au, mingo@elte.hu,
       herbert@gondor.apana.org.au, akpm@linux-foundation.org, hpa@zytor.com,
       brgerst@gmail.com, ebiederm@xmission.com, travis@sgi.com,
       linux-kernel@vger.kernel.org, steiner@sgi.com, hugh@veritas.com,
       netdev@vger.kernel.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
In-Reply-To: <20090127.134747.153565246.davem@davemloft.net>
Message-ID: <alpine.DEB.1.10.0901281145050.13825@qirst.com>
References: <200901271213.18605.rusty@rustcorp.com.au> <497E705B.5000302@kernel.org> <alpine.DEB.1.10.0901271506580.3114@qirst.com> <20090127.134747.153565246.davem@davemloft.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009, David Miller wrote:

> > Why wont it scale? this is a separate TLB entry for each processor.
>
> The IA64 per-cpu TLB entry only covers 64k which makes use of it for
> dynamic per-cpu stuff out of the question.  That's why it "doesn't
> scale"

IA64 supports varying page sizes. You can use a 128k TLB entry etc.

