Return-Path: <linux-kernel-owner+w=401wt.eu-S933586AbYCDUie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586AbYCDUie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 15:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbYCDUiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 15:38:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756528AbYCDUiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 15:38:23 -0500
Date: Tue, 4 Mar 2008 15:38:00 -0500
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org
Subject: Re: [patch 03/21] use an array for the LRU pagevecs
Message-ID: <20080304153800.4cadcc93@cuia.boston.redhat.com>
In-Reply-To: <20080304200209.1EAB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080229154056.GF28849@shadowen.org>
	<20080301153941.528A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080304200209.1EAB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Mar 2008 20:04:05 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi Rik
> 
> this is fixed patch of Andy Whitcroft's point out.
> (at least, I hope it)

Applied, except for the documentation to ____pagevec_lru_add, since
that function should, IMHO, probably stay internal to the VM and not
be exposed in documentation.

-- 
All Rights Reversed
