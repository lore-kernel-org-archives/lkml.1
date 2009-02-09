Return-Path: <linux-kernel-owner+w=401wt.eu-S1755797AbZBIQrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbZBIQrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 11:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZBIQri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 11:47:38 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48050 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbZBIQrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 11:47:37 -0500
Subject: Re: mm_alloc()'ed structure leak
From: Peter Zijlstra <peterz@infradead.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <1234197950.5951.132.camel@laptop>
References: <1234181898.16083.26.camel@pc1117.cambridge.arm.com>
	 <1234190649.16083.44.camel@pc1117.cambridge.arm.com>
	 <1234192363.5951.129.camel@laptop>  <1234197950.5951.132.camel@laptop>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 17:47:03 +0100
Message-Id: <1234198023.5951.133.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 17:45 +0100, Peter Zijlstra wrote:
> -               return -ERESTART_RESTARTBLOCK;
> +               ret = -ERESTARTSYS;

noted and fixed.

