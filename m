Return-Path: <linux-kernel-owner+w=401wt.eu-S1760009AbYCYVP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009AbYCYVP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbYCYVPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:15:19 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51624 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbYCYVPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:15:18 -0400
Message-ID: <47E96B0A.2010906@cs.helsinki.fi>
Date: Tue, 25 Mar 2008 23:13:46 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Daniel Yeisley <dan.yeisley@unisys.com>
CC: linux-kernel@vger.kernel.org, akpm@osdl.org,
       Christoph Lameter <clameter@sgi.com>, mel@csn.ul.ie
Subject: Re: [PATCH] list_add corruption in slab.c
References: <1206464258.13473.11.camel@localhost.localdomain>	 <84144f020803251145m6672e0acv16d27aaae1acb4d9@mail.gmail.com> <1206477858.8810.3.camel@localhost.localdomain>
In-Reply-To: <1206477858.8810.3.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Daniel Yeisley wrote:
> I actually saw that initkmem_list reference, but didn't change it since
> my original patch fixed my list corruption.  Anyway, I made the changed
> and tested it.  The system booted fine.

Yeah, but the second change is needed; otherwise we forget to fix up 
some of the bootstrap caches.

 > ﻿Signed-off-by: Dan Yeisley <dan.yeisley@unisys.com>

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

Mel, as this change is related to the memoryless node fix that went in 
2.6.24, any chance you'd give this patch a spin on your machines so we 
can get the fix in 2.6.25 and 2.6.24-stable?

			Pekka
