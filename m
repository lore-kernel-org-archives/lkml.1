Return-Path: <linux-kernel-owner+w=401wt.eu-S1762773AbZBYQD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762773AbZBYQD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbZBYQDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:03:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58539 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbZBYQDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:03:19 -0500
Subject: Re: [PATCH 00/15] bitops: Change bitmap index from int to unsigned
 long
From: Peter Zijlstra <peterz@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Justin Chen <jchen@hpdst41.cup.hp.com>, linux-arch@vger.kernel.org,
       bjorn.helgaas@hp.com, justin.chen@hp.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090225155347.GR16891@parisc-linux.org>
References: <200902250441.UAA12527@hpdst41.cup.hp.com>
	 <1235544888.4645.2942.camel@laptop>
	 <20090225153757.GP16891@parisc-linux.org>
	 <1235576760.4645.3535.camel@laptop>
	 <20090225155347.GR16891@parisc-linux.org>
Content-Type: text/plain
Date: Wed, 25 Feb 2009 17:03:15 +0100
Message-Id: <1235577795.4645.3575.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-25 at 08:53 -0700, Matthew Wilcox wrote:
> I don't see the downside to using unsigned long instead of unsigned int.

OK, I guess, it just seemed plenty large enough, but if you're actually
running off the end..

