Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbXFXTGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbXFXTGI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 15:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbXFXTF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 15:05:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625AbXFXTF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 15:05:56 -0400
Date: Sun, 24 Jun 2007 12:04:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
In-Reply-To: <20070624183547.GA21478@ftp.linux.org.uk>
Message-ID: <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org>
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk> <20070624174732.GZ21478@ftp.linux.org.uk>
 <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org>
 <20070624183547.GA21478@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 24 Jun 2007, Al Viro wrote:
> 
> Why?  I'd say it's not better than BUILD_BUG_ON_ZERO() use
> instead of that ?:

Oh, _that_ part I have no problem with. It's more that it seems that the 
gcc optimization is ok at least as an extension.

		Linus
