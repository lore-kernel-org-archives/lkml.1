Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbYBVPcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbYBVPcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 10:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbYBVPcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 10:32:45 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59410 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbYBVPcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 10:32:45 -0500
Date: Fri, 22 Feb 2008 07:30:43 -0800
From: Greg KH <greg@kroah.com>
To: Kohei KaiGai <kaigai@ak.jp.nec.com>
Cc: "Andrew G. Morgan" <morgan@kernel.org>, serue@us.ibm.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] exporting capability name/code pairs (final)
Message-ID: <20080222153043.GC10954@kroah.com>
References: <47BE2A29.4010302@ak.jp.nec.com> <47BE8A10.3080103@kernel.org> <47BE99BC.2060707@ak.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BE99BC.2060707@ak.jp.nec.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 06:45:32PM +0900, Kohei KaiGai wrote:
> I believe it is correct assumption that long type and pointers have
> same width in the linux kernel. Please tell me, if it is wrong.

That is correct, it is one of the assumptions that is safe to make.  But
you should fix the compiler warning :)

thanks,

greg k-h
