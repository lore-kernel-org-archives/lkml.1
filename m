Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbYBMHCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbYBMHCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbYBMHCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:02:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48522 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbYBMHCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:02:33 -0500
Date: Wed, 13 Feb 2008 02:02:28 -0500
From: Christoph Hellwig <hch@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: chris.mason@oracle.com, jengelh@computergmbh.de,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       btrfs-devel@oss.oracle.com
Subject: Re: BTRFS partition usage...
Message-ID: <20080213070228.GA3301@infradead.org>
References: <200802120908.59602.chris.mason@oracle.com> <Pine.LNX.4.64.0802121518500.21102@fbirervta.pbzchgretzou.qr> <200802120935.20437.chris.mason@oracle.com> <20080212.153557.159395336.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212.153557.159395336.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 03:35:57PM -0800, David Miller wrote:
> What XFS does is really unfortunate, let's learn from it's
> mistake.

I'd rather say what Sun did with their disklabels was rather unfortunate :)
But yeah, new filesystem should cater for it's braindamage because it
doesn't have any kind of runtime cost at all.   XFS was designed for
IRIX back then which had disklabels just like the SUN ones, just without
the braindamage of having the disklabel inside the partition..

