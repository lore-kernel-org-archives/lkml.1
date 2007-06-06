Return-Path: <linux-kernel-owner+w=401wt.eu-S1765581AbXFFLea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765581AbXFFLea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 07:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761814AbXFFLeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 07:34:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50245 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761048AbXFFLeC (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 07:34:02 -0400
Date: Wed, 6 Jun 2007 12:33:51 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jared Hulbert <jaredeh@gmail.com>
Cc: carsteno@de.ibm.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Message-ID: <20070606113351.GA11701@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jared Hulbert <jaredeh@gmail.com>, carsteno@de.ibm.com,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	richard.griffiths@windriver.com,
	Richard Griffiths <res07ml0@verizon.net>,
	Linux-kernel@vger.kernel.org
References: <1179871779.24163.11.camel@localhost.localdomain> <20070522154905.1d7e8a2e.akpm@linux-foundation.org> <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au> <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com> <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com> <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I might be a little late in the discussion, but I somehow missed this
before.  Please don't add this xip support to cramfs, because the
whole point of cramfs is to be a simple _compressed_ filesystem,
and we really don't want to add more complexity to it.  Please
use something like the existing ext2 xip mode instead of add support
to romfs using the generic filemap methods.

