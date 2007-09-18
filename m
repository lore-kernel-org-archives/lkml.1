Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbXIRLKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbXIRLKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 07:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbXIRLKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 07:10:03 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56232 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbXIRLKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 07:10:00 -0400
Date: Tue, 18 Sep 2007 12:09:57 +0100
From: Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: 2.6.20 (XFS? related) crash after uptime of > 180 days during apt-get dist-upgrade on Debian Testing
Message-ID: <20070918110957.GA5385@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Chinner <dgc@sgi.com>,
	Justin Piszcz <jpiszcz@lucidpixels.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com
References: <Pine.LNX.4.64.0709171315210.22156@p34.internal.lan> <20070918014537.GK23367404@sgi.com> <20070918092013.GA1352@infradead.org> <20070918103916.GV23367404@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918103916.GV23367404@sgi.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 08:39:16PM +1000, David Chinner wrote:
> The i_sem leak was hitting us on sles9 - 2.6.5 base kernel - and it was fixed
> before the i_sem -> i_mutex conversion in mainline. Some time around 2.6.16,
> IIRC. Given this was a 2.6.20 kernel, there'd be an almighty kaboom if that
> bug still existed after the i_mutex conversion....

We didn't fix it before the i_mutex conversion - I saw the mutex debugging
messages after the i_mutex conversion, but didn't see the corelation.
Probably still long before 2.6.22, though.

