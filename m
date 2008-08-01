Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbYHAN3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbYHAN3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 09:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYHAN27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 09:28:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751162AbYHAN26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 09:28:58 -0400
Message-ID: <48930F69.30201@linux-foundation.org>
Date: Fri, 01 Aug 2008 08:28:09 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: penberg@cs.helsinki.fi, akpm@linuxfoundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SLUB: detach SLUB_DEBUG and SYSFS
References: <20080801000405.GA7072@martell.zuzino.mipt.ru>
In-Reply-To: <20080801000405.GA7072@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> Right now, SYSFS=n means no SLUB debugging, no even basic poisoning,
> to hell with tunables.

True. We did this because otherwise we would have complex #ifdeffery in slub.

commit f6acb63508700b5f8cd817082b62c96ba907775e
Author: Christoph Lameter <clameter@sgi.com>
Date:   Tue Apr 29 16:16:06 2008 -0700

    slub: #ifdef simplification

    If we make SLUB_DEBUG depend on SYSFS then we can simplify some
    #ifdefs and avoid others.

    Signed-off-by: Christoph Lameter <clameter@sgi.com>
    Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

