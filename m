Return-Path: <linux-kernel-owner+w=401wt.eu-S2992947AbXCIE1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992947AbXCIE1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 23:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992948AbXCIE1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 23:27:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60081
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2992947AbXCIE1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 23:27:18 -0500
Date: Thu, 08 Mar 2007 20:27:18 -0800 (PST)
Message-Id: <20070308.202718.68040662.davem@davemloft.net>
To: hpa@zytor.com
Cc: anton@samba.org, hch@infradead.org, arjan@infradead.org,
       zippel@linux-m68k.org, dmlb2000@gmail.com, linux-kernel@vger.kernel.org,
       gdb@sourceware.org
Subject: Re: PAGE_SIZE Availability Inconsistency
From: David Miller <davem@davemloft.net>
In-Reply-To: <45F0E014.8060907@zytor.com>
References: <20070308.134825.45514445.davem@davemloft.net>
	<20070309024324.GA24695@kryten>
	<45F0E014.8060907@zytor.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 08 Mar 2007 20:18:28 -0800

> Anton Blanchard wrote:
> > The other option is to create a v3 swap format that doesnt use any
> > PAGE_SIZE parameters.
> 
> The best thing to do would be to look for the magic both at PAGE_SIZE 
> (for compatibility) and MIN_PAGE_SIZE (for sanity.)

That might work, but a large part of me says to go for v3
and do it cleanly.
