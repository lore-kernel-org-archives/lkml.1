Return-Path: <linux-kernel-owner+w=401wt.eu-S1760233AbXIUOrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233AbXIUOrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758047AbXIUOra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:47:30 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:60185 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866AbXIUOr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:47:29 -0400
Date: Fri, 21 Sep 2007 10:47:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Gilboa Davara <gilboad@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Minor patch] Reduce __print_symbol/sprint_symbol stack usage.
Message-ID: <20070921144726.GD15697@goodmis.org>
References: <1189856129.18191.11.camel@gilboa-home-dev.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189856129.18191.11.camel@gilboa-home-dev.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 02:35:29PM +0300, Gilboa Davara wrote:
> -		return sprintf(buffer, "%s+%#lx/%#lx", name, offset, size);
> +	if (namebuf)
> +		kfree(namebuf);

Note, the if condition is not needed, kfree handles null pointers fine.

-- Steve
