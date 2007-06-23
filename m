Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbXFWKGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbXFWKGP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 06:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbXFWKGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 06:06:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45393 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbXFWKGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 06:06:06 -0400
Date: Sat, 23 Jun 2007 11:06:00 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, David Smith <dsmith@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 03/10] Allow userspace applications to use marker.h to parse the markers section in the kernel binary.
Message-ID: <20070623100600.GA31638@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	David Smith <dsmith@redhat.com>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070510015555.973107048@polymtl.ca> <20070510020915.900170085@polymtl.ca> <20070510065137.GA7943@infradead.org> <46439941.4010909@redhat.com> <20070623080953.GA29241@infradead.org> <20070623102515.3a1fc583@the-village.bc.nu> <20070623093209.GB30849@infradead.org> <20070623104905.20ae2929@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070623104905.20ae2929@the-village.bc.nu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 10:49:05AM +0100, Alan Cox wrote:
> The system to create the dynamic modules could certainly be in-tree but to
> argue that code dynamically created should be "in tree" already is a
> bit silly really isn't it ?

I never argued that.  Creating them intree is equivalent to having the
generated modules in tree for all purposes related to interface stability.

The important bit is that we should not even pretend to allow external
users that we keep a tiny part of the interface stable while the major
part isn't.
