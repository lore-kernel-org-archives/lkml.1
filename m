Return-Path: <linux-kernel-owner+w=401wt.eu-S1762897AbZEHPjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762897AbZEHPjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbZEHPiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:38:46 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:46947 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753323AbZEHPip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:38:45 -0400
Date: Fri, 8 May 2009 11:28:04 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: akpm@linux-foundation.org, gorcunov@openvz.org,
       kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, rientjes@google.com
Subject: Re: [PATCH 2/2] SLUB: Use GFP_PANIC for early-boot allocations
In-Reply-To: <1241795429.28600.61.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0905081127240.26361@qirst.com>
References: <1241795429.28600.61.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009, Pekka Enberg wrote:

> This patch converts SLUB early-boot code to use GFP_PANIC instead of explicit
> BUG_ON() calls.

Yirks this is not only early boot code. create_unique_id may be executed
whenever a slab is created.


