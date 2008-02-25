Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbYBYGtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbYBYGtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 01:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755663AbYBYGtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 01:49:24 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57156 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbYBYGtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 01:49:22 -0500
Date: Sun, 24 Feb 2008 22:51:07 -0800
From: Greg KH <greg@kroah.com>
To: Kohei KaiGai <kaigai@ak.jp.nec.com>
Cc: morgan@kernel.org, serue@us.ibm.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] add a private data field within kobj_attribute
	structure (final#2)
Message-ID: <20080225065106.GB20997@kroah.com>
References: <47C25AE9.7080305@ak.jp.nec.com> <47C25BD3.3020205@ak.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C25BD3.3020205@ak.jp.nec.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 03:10:27PM +0900, Kohei KaiGai wrote:
> [PATCH 1/3] add a private data field within kobj_attribute structure.
> 
> This patch add a private data field, declared as void *, within kobj_attribute
> structure. The _show() and _store() method in the sysfs attribute entries can
> refer this information to identify what entry is accessed.
> It makes easier to share a single method implementation with several similar
> entries, like ones to export the list of capabilities the running kernel
> supports.
> 
> Signed-off-by: KaiGai Kohei <kaigai@ak.jp.nec.com>
> --
>  Documentation/kobject.txt |    6 ++++++

That's good, but you didn't modify the sample/kobject/ file to use the
new void pointer, instead of the strcmp() call.

thanks,

greg k-h
