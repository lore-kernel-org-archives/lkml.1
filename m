Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbYE3WMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbYE3WMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 18:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYE3WMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 18:12:22 -0400
Received: from saeurebad.de ([85.214.36.134]:34276 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbYE3WMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 18:12:21 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mm 08/14] bootmem: clean up alloc_bootmem_core
References: <20080530194220.286976884@saeurebad.de>
	<20080530194738.789921715@saeurebad.de>
Date: Sat, 31 May 2008 00:11:43 +0200
In-Reply-To: <20080530194738.789921715@saeurebad.de> (Johannes Weiner's
	message of "Fri, 30 May 2008 21:42:28 +0200")
Message-ID: <87ej7jmogw.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Johannes Weiner <hannes@saeurebad.de> writes:

> alloc_bootmem_core has become quite nasty to read over time.  This is
> a clean rewrite that keeps the semantics.

Another ->last_success error (missed updating it).

I already have a fixed up series here, will wait a bit for sending it
out to incorporate feedback as well.

	Hannes
