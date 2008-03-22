Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbYCVUvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbYCVUvX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 16:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYCVUvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 16:51:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50955 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYCVUvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 16:51:15 -0400
Date: Sat, 22 Mar 2008 13:48:14 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: yhlu.kernel@gmail.com
Cc: yhlu.kernel.send@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: early memtest to find bad ram
Message-ID: <20080322134814.7258ff0c@laptopd505.fenrus.org>
In-Reply-To: <200803202358.33722.yhlu.kernel@gmail.com>
References: <200803202358.33722.yhlu.kernel@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008 23:58:33 -0700
Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> 
> do simple memtest after init_memory_mapping
> 
> use find_e820_area_size to find all ram range that is not reserved.

be careful, there's some special memory that e820 right now says is not reserved,
but still has bios data (the first 4Kb of memory come to mind)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
