Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbXFXUTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbXFXUTU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 16:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbXFXUTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 16:19:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36221 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbXFXUTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 16:19:08 -0400
Subject: Re: [patch 1/3] add the fsblock layer
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <p73fy4h5q3c.fsf@bingen.suse.de>
References: <20070624014528.GA17609@wotan.suse.de>
	 <20070624014613.GB17609@wotan.suse.de>  <p73fy4h5q3c.fsf@bingen.suse.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 24 Jun 2007 13:18:42 -0700
Message-Id: <1182716322.6819.3.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Hmm, could define a macro DECLARE_ATOMIC_BITMAP(maxbit) that expands to the smallest
> possible type for each architecture. And a couple of ugly casts for set_bit et.al.
> but those could be also hidden in macros. Should be relatively easy to do.

or make a "smallbit" type that is small/supported, so 64 bit if 32 bit
isn't supported, otherwise 32


