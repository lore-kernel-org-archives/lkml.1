Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbXHVFpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbXHVFpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 01:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbXHVFpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 01:45:43 -0400
Received: from canuck.infradead.org ([209.217.80.40]:51867 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbXHVFpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 01:45:42 -0400
Date: Tue, 21 Aug 2007 22:48:55 -0700
From: Greg KH <greg@kroah.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Console events and accessibility
Message-ID: <20070822054855.GB23336@kroah.com>
References: <20070821212939.GD3658@interface.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821212939.GD3658@interface.famille.thibault.fr>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 11:29:39PM +0200, Samuel Thibault wrote:
> Some external modules like Speakup need to monitor console output.
> 
> This adds a VT notifier that such modules can use to get console output events:
> allocation, deallocation, writes, other updates (cursor position, switch, etc.)
> 
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

Will speakup work with this kind of change?

thanks,

greg k-h
