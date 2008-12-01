Return-Path: <linux-kernel-owner+w=401wt.eu-S1752665AbYLAOuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbYLAOuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbYLAOuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:50:32 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:58117 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYLAOuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:50:32 -0500
Date: Mon, 1 Dec 2008 08:49:11 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Hugh Dickins <hugh@veritas.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Jones <davej@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2/8] badpage: keep any bad page out of circulation
In-Reply-To: <Pine.LNX.4.64.0812010040330.11401@blonde.site>
Message-ID: <Pine.LNX.4.64.0812010848160.15331@quilx.com>
References: <Pine.LNX.4.64.0812010032210.10131@blonde.site>
 <Pine.LNX.4.64.0812010040330.11401@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008, Hugh Dickins wrote:

> Until now the bad_page() checkers have special-cased PageReserved, keeping
> those pages out of circulation thereafter.  Now extend the special case to
> all: we want to keep ANY page with bad state out of circulation - the
> "free" page may well be in use by something.

If I screw up with a VM patch then my machine will now die because of OOM
instead of letting me shutdown and reboot?
