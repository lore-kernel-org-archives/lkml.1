Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbZBGU33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbZBGU33 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 15:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZBGU3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 15:29:21 -0500
Received: from waste.org ([66.93.16.53]:40104 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbZBGU3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 15:29:20 -0500
Subject: Re: [PATCH/RFC] Fasync BKL removal
From: Matt Mackall <mpm@selenic.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>,
       David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1234037217-16124-1-git-send-email-corbet@lwn.net>
References: <1234037217-16124-1-git-send-email-corbet@lwn.net>
Content-Type: text/plain
Date: Sat, 07 Feb 2009 14:28:26 -0600
Message-Id: <1234038506.3243.265.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-07 at 13:06 -0700, Jonathan Corbet wrote:
> With any luck at all, this is my final attempt at removing the BKL from the
> fasync() path and providing proper protection for struct file->f_flags.
> This week's episode includes these patches:

This all looks very pretty to me.

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
http://selenic.com : development and support for Mercurial and Linux


