Return-Path: <linux-kernel-owner+w=401wt.eu-S1752698AbYCJQEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbYCJQEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 12:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbYCJQE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 12:04:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34948 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbYCJQEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 12:04:25 -0400
Date: Mon, 10 Mar 2008 09:03:17 -0700
From: Greg KH <greg@kroah.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: inotify fixes in stable
Message-ID: <20080310160317.GB20775@kroah.com>
References: <20080310091155.02b7fe0e@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310091155.02b7fe0e@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 09:11:55AM +0100, Pierre Ossman wrote:
> Hi Greg,
> 
> I was hoping that the fixes for bug 7785 "BUG: at fs/inotify.c:172
> set_dentry_child_flags()" could be added to the stable releases. I'm
> seeing these quite frequently at customer installations.

In the future, stable stuff should be sent to the stable@kernel.org
email address and not directly to me, thanks.

> The relevant commits are d599e36a9ea85432587f4550acc113cd7549d12a and
> 0d71bd5993b630a989d15adc2562a9ffe41cd26d. Hopefully these do not
> depend on other updates. Nick would be the expert on that.

Can you verify that if you apply just those 2 patches to the latest
2.6.24.3 kernel release, it fixes the issues for you?

thanks,

greg k-h
