Return-Path: <linux-kernel-owner+w=401wt.eu-S938741AbXGSOLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938741AbXGSOLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934812AbXGSN5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:57:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48651 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938400AbXGSN5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:57:12 -0400
Date: Thu, 19 Jul 2007 14:57:08 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Karel Zak <kzak@redhat.com>, Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH][RFC] Delete export of tty.h to userspace.
Message-ID: <20070719135707.GA16279@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Karel Zak <kzak@redhat.com>, Jiri Slaby <jirislaby@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <Pine.LNX.4.64.0707180520040.19434@localhost.localdomain> <469E7599.4060608@gmail.com> <Pine.LNX.4.64.0707181631340.14452@localhost.localdomain> <20070718223820.GF3181@petra.dvoda.cz> <Pine.LNX.4.64.0707190715320.25024@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707190715320.25024@localhost.localdomain>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 07:17:07AM -0400, Robert P. J. Day wrote:
> so you're saying you'll drop that include from util-linux, is that it?
> but it's still a good plan to generate a warning whenever userspace
> includes that file, so i'll submit a quick patch to generate that,
> based on jiri's suggestion.

Not exporting it at all gives an error which is a lot better.  Just look
at all the warnings most userspace spews, they'd never even notice it
otherwise.

