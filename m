Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbXFWJcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbXFWJcW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 05:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbXFWJcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 05:32:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51027 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbXFWJcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 05:32:14 -0400
Date: Sat, 23 Jun 2007 10:32:09 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, David Smith <dsmith@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 03/10] Allow userspace applications to use marker.h to parse the markers section in the kernel binary.
Message-ID: <20070623093209.GB30849@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	David Smith <dsmith@redhat.com>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070510015555.973107048@polymtl.ca> <20070510020915.900170085@polymtl.ca> <20070510065137.GA7943@infradead.org> <46439941.4010909@redhat.com> <20070623080953.GA29241@infradead.org> <20070623102515.3a1fc583@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070623102515.3a1fc583@the-village.bc.nu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 10:25:15AM +0100, Alan Cox wrote:
> Getting the marker exports right is what is needed to avoid having an
> unreliable parser and ending up with a reliable one.
> 
> Or would you rather someone loaded a JVM into kernel space so it was
> "shipped with the kernel"

You're totall missing the point here.  We're talking about kernel internal
interface, and the point for them has always been not to care about out
of tree users.  There is no relation to anything involving a JVM here.

