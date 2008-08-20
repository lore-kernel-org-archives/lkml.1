Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbYHTOLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbYHTOLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 10:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbYHTOLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 10:11:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40351 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbYHTOLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 10:11:00 -0400
Subject: Re: [PATCH 1/2] byteorder: add new headers for make headers-install
From: David Woodhouse <dwmw2@infradead.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1219091880.23637.5.camel@brick>
References: <1219091880.23637.5.camel@brick>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 15:10:54 +0100
Message-Id: <1219241454.2988.155.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 13:38 -0700, Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Andrew, two fixes before the arches start moving over.

We don't expose cpu_to_le32() et al., do we? Only __cpu_to_le32() and
similar? Which exported headers use these -- and are they actually using
the __ versions? If not, they're not going to work anyway, are they?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



