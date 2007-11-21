Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbXKUWZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbXKUWZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 17:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbXKUWZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 17:25:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47252 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751921AbXKUWZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 17:25:45 -0500
Date: Wed, 21 Nov 2007 14:25:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <k.shutemov@velesys.com>
Cc: hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org, avi@qumranet.com,
       tglx@linutronix.de, mingo@elte.hu
Subject: Re: 2.6.24-rc3-mm1
Message-Id: <20071121142520.41f16d6e.akpm@linux-foundation.org>
In-Reply-To: <20071121183513.GB4280@localhost.localdomain>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<a8e1da0711202151t6c9d52acjf1f876085b95dfce@mail.gmail.com>
	<20071120220046.db5c8fde.akpm@linux-foundation.org>
	<a8e1da0711202203v6a2a9945pcfa5cfe67b83b504@mail.gmail.com>
	<20071120221552.1f42ebfa.akpm@linux-foundation.org>
	<20071121183513.GB4280@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 20:35:13 +0200
"Kirill A. Shutemov" <k.shutemov@velesys.com> wrote:

> Symbol init_level4_pgt is needed by nvidia module. Is it really need to 
> unexport it?

It's our clever way of reducing the tester base so we don't get so many
bug reports.
