Return-Path: <linux-kernel-owner+w=401wt.eu-S1761358AbYBVRFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761358AbYBVRFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 12:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbYBVRFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 12:05:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56810 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953AbYBVRFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 12:05:36 -0500
Date: Fri, 22 Feb 2008 09:04:59 -0800
From: Greg KH <greg@kroah.com>
To: Kohei KaiGai <kaigai@ak.jp.nec.com>
Cc: morgan@kernel.org, serue@us.ibm.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] exporting capability name/code pairs (final)
Message-ID: <20080222170459.GB18524@kroah.com>
References: <47BE2A26.1080806@ak.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BE2A26.1080806@ak.jp.nec.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 10:49:26AM +0900, Kohei KaiGai wrote:
> [1/3] Add a private data field within kobj_attribute structure.

Your "Subject" did not line up with this description, please change your
patch sending format for the next time.

> This patch add a private data field, declared as void *, within kobj_attribute
> structure. The _show() and _store() method in the sysfs attribute entries can
> refer this information to identify what entry is accessed.
> It makes easier to share a single method implementation with several similar
> entries, like ones to export the list of capabilities the running kernel
> supported.
> 
> Signed-off-by: KaiGai Kohei <kaigai@ak.jp.nec.com>

This looks fine, but I'll not take it unless the documentation is
updated, as well as the sample code.

thanks,

greg k-h
