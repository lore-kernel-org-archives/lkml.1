Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbYEPH3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbYEPH3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 03:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYEPH33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 03:29:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40821 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYEPH32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 03:29:28 -0400
Date: Fri, 16 May 2008 00:29:07 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Problems with suspend and USB storage
Message-ID: <20080516072907.GA21157@kroah.com>
References: <20080515163315.GA17779@nostromo.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515163315.GA17779@nostromo.devel.redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 12:33:15PM -0400, Bill Nottingham wrote:
> 
> I've been testing suspend/hibernate with various USB devices under
> 2.6.25.2. Test box is a Thinkpad T60 (uhci, ehci).
> The results are somewhat dismal.

If you look at 2.6.26-rc, there are some good changes there that should
help things out a lot.  USB_PERSIST is much better there, but it missed
.25 as it wasn't tested enough (although it is shipping in openSUSE
11.0, and seems to be working well there...)

thanks,

greg k-h
