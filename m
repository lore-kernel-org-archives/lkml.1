Return-Path: <linux-kernel-owner+w=401wt.eu-S1761834AbXHISXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761834AbXHISXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbXHISX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:23:26 -0400
Received: from gw01.mail.saunalahti.fi ([195.197.172.115]:44447 "EHLO
	gw01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbXHISXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:23:25 -0400
Date: Thu, 9 Aug 2007 21:23:16 +0300
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: early boot lockup with 2.6.23-rc1
Message-ID: <20070809182316.GA2289@nalle>
References: <20070808223120.GA2286@nalle> <46BAC14E.9040604@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46BAC14E.9040604@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 12:25:02AM -0700, H. Peter Anvin wrote:
> It might be an issue with the new setup code.  What happens if you
> append "vga=ask" to the kernel command line?

I get to choose the vga mode but nothing visible happens after that.
This seems like regression since even 2.6.23-rc2 from Debian
experimental (2.6.23~rc2-1~experimental.1~snapshot.9254) hangs the same
way. I've tried -git's upto 2.6.22-git5 which fails too.

Which patch included this new setup code?

-Mikko
