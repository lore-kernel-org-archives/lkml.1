Return-Path: <linux-kernel-owner+w=401wt.eu-S1764107AbXHWOil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764107AbXHWOil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 10:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763162AbXHWOic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 10:38:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59811 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762840AbXHWOic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 10:38:32 -0400
Date: Thu, 23 Aug 2007 07:32:41 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Renumber AUDIT_TTY_[GS]ET
Message-ID: <20070823073241.2c470cb5@laptopd505.fenrus.org>
In-Reply-To: <20070823091953.GK21089@ftp.linux.org.uk>
References: <20070823091953.GK21089@ftp.linux.org.uk>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007 10:19:53 +0100
Al Viro <viro@ftp.linux.org.uk> wrote:

> From: Miloslav Trmac <mitr@redhat.com>
> 
> Renumber AUDIT_TTY_[GS]ET to avoid a conflict with netlink message
> types already used in the wild.

which are these? Were they in mainline or -mm before?

also, if this is so sensitive, at least add something that says to never ever use 1014/1015...
