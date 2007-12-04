Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbXLDVgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbXLDVgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbXLDVgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:36:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59189 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbXLDVgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:36:06 -0500
Date: Tue, 4 Dec 2007 13:34:05 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Paulo Marques <pmarques@grupopie.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [-mm PATCH] kallsyms should prefer non weak symbols
Message-ID: <20071204133405.13ccd3bb@laptopd505.fenrus.org>
In-Reply-To: <4755BA14.8060706@grupopie.com>
References: <4755BA14.8060706@grupopie.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Dec 2007 20:35:32 +0000
Paulo Marques <pmarques@grupopie.com> wrote:

> 
> When resolving symbol names from addresses with aliased symbol names, 
> kallsyms_lookup always returns the first symbol, even if it is a weak 
> symbol.
> 
> This patch changes this by sorting the symbols with the weak symbols 
> last before feeding them to the kernel. This way the kernel runtime 
> isn't changed at all, only the kallsyms build system is changed.
> 

what user of this api is affected by this?


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
