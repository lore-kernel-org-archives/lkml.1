Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbXFOEi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbXFOEi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 00:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbXFOEiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 00:38:19 -0400
Received: from ozlabs.org ([203.10.76.45]:50555 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbXFOEiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 00:38:18 -0400
Subject: Re: [PATCH 2/2] readahead: sanify file_ra_state names
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Fengguang Wu <wfg@mail.ustc.edu.cn>
In-Reply-To: <20070614062816.085421580@mail.ustc.edu.cn>
References: <20070614062447.058708836@mail.ustc.edu.cn>
	 <20070614062816.085421580@mail.ustc.edu.cn>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 14:38:07 +1000
Message-Id: <1181882288.6237.205.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-14 at 14:21 +0800, Fengguang Wu wrote:
> plain text document attachment (readahead-rename.patch)
> Rename some file_ra_state variables and remove some accessors.
> 
> It results in much simpler code.
> Kudos to Rusty!
> 
> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>

Needless to say, I'm now very satisfied with the new readahead code.  

That's not to say there won't be corner cases where the old code did
better, but given the replacement's simplicity and Fengguang's positive
benchmark results I really like it.

Thanks for Fengguang for coding and pushing this!
Rusty.


