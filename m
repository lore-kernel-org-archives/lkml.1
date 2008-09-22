Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbYIVWXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbYIVWXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 18:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbYIVWXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 18:23:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:58597 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbYIVWXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 18:23:38 -0400
Date: Mon, 22 Sep 2008 15:20:30 -0700
From: Greg KH <greg@kroah.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       stable@kernel.org
Subject: Re: [stable] [PATCH] Only register notifiers when the braille
	console is used.
Message-ID: <20080922222030.GA21811@kroah.com>
References: <20080922214031.GJ5930@implementation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922214031.GJ5930@implementation>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 11:40:31PM +0200, Samuel Thibault wrote:
> Only register the braille driver VT and keyboard notifiers when the
> braille console is used.  Avoids eating insert or backspace keys.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=11242
> 
> Signed-off-by: Pascal Terjan <pterjan@mandriva.com>
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

As this patch isn't upstream yet, if you want it to be included
automatically in the next -stable release when it is added to Linus's
tree, just add a:
  Cc: stable <stable@kernel.org>

to the signed-off-by: area.  When it goes into Linus's tree, we will
automatically get notified and it will then be added to the -stable tree
with no additional work for you.

hope this helps,

greg k-h
