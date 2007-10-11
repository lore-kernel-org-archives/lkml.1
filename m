Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbXJKPk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbXJKPk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 11:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbXJKPkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 11:40:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34911 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbXJKPkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 11:40:18 -0400
Date: Thu, 11 Oct 2007 08:38:27 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mgross@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, linux-pm@lists.linux-foundation.org,
       mark.gross@intel.com
Subject: Re: pm qos infrastructure and interface
Message-ID: <20071011083827.3b964620@laptopd505.fenrus.org>
In-Reply-To: <20071010221704.6e438c71.akpm@linux-foundation.org>
References: <20071004215139.GA20078@linux.intel.com>
	<20071010221704.6e438c71.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2007 22:17:04 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> I'm a bit surprised that this change appears to have no
> configurability. If one has set CONFIG_PM=n (for example), shouldn't
> it all go away?

I suppose it's a matter of taste, but at least personally I believe that
userspace exposed ABI's shouldn't be configurable as a starting point
(if the code delta is 100's of kilobytes it's a different topic); what
point is talking about a stable ABI if it's there or not half the
time... that's the ultimate instability.
