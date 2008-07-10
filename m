Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbYGJIl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbYGJIl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 04:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYGJIlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 04:41:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340AbYGJIlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 04:41:49 -0400
Date: Thu, 10 Jul 2008 01:35:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jack Steiner <steiner@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] - Map UV chipset space - pagetable
Message-Id: <20080710013533.e059f556.akpm@linux-foundation.org>
In-Reply-To: <20080701194532.GA28405@sgi.com>
References: <20080701194532.GA28405@sgi.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2008 14:45:32 -0500 Jack Steiner <steiner@sgi.com> wrote:

> +	BUG_ON((phys & ~PMD_MASK) || (size & ~PMD_MASK));

BUG_ON(A || B) is usually a bad idea.  If it goes bang, you'll really wish
that it had been

	BUG_ON(A);
	BUG_ON(B);
