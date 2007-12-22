Return-Path: <linux-kernel-owner+w=401wt.eu-S1759042AbXLVAVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbXLVAVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 19:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbXLVAVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 19:21:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58071 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216AbXLVAVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 19:21:30 -0500
Date: Fri, 21 Dec 2007 16:21:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org, bfennema@falcon.csc.calpoly.edu,
       jack@suse.cz
Subject: Re: [PATCH 1/5] udf: remove wrong prototype of udf_readdir
Message-Id: <20071221162117.faa3d16d.akpm@linux-foundation.org>
In-Reply-To: <20071221155453.GA8575@joi>
References: <20071221155453.GA8575@joi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007 16:55:03 +0100
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> sparse generated:
> fs/udf/dir.c:78:5: warning: symbol 'udf_readdir' was not declared. Should it be static?
> there are 2 different prototypes of udf_readdir - remove them and move
> code around to make it still compile

Drat.  I just applied six udf patches from you and now we have a new patch
series of only five with no indication what changed.

I guess I really do need to apply my backlog in reverse time order.

