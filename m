Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbZLAR1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbZLAR1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbZLAR1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:27:14 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:60623 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbZLAR1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:27:03 -0500
Date: Tue, 1 Dec 2009 11:26:37 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: David John <davidjon@xenontk.org>, linux-kernel@vger.kernel.org,
       Jonathan Miles <jon@cybus.co.uk>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: OOM kernel behaviour
In-Reply-To: <4B154E10.7050300@xenontk.org>
Message-ID: <alpine.DEB.2.00.0912011124490.10426@router.home>
References: <4B1402FC.80307@cybus.co.uk> <4B1537CA.7020107@xenontk.org> <alpine.DEB.2.00.0912011007360.8841@router.home> <4B154E10.7050300@xenontk.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.DEB.2.00.0912011124492.10426@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009, David John wrote:

> Here are three logs from three days. Log3.txt is today's log and the OOM
> killer murdered Thunderbird as I was attempting to write this message.
> The kernel config is also attached.

Hmmm... This is all caused by the HIGHMEM zone freecount going beyond min
which then triggers reclaim which for some reason fails (should not there
is sufficient material there to reclaim). There is enough memory in the
NORMAL zone. Wonder if something broke in 2.6.31 in reclaim? Mel?

