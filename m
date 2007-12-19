Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbXLSPAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbXLSPAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 10:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbXLSPAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 10:00:04 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:2371 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320AbXLSPAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 10:00:00 -0500
Date: Wed, 19 Dec 2007 09:29:02 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Greg KH <gregkh@suse.de>, Johannes Berg <johannes@sipsolutions.net>,
       Mattias Nissler <mattias.nissler@gmx.de>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/8] debugfs: allow access to signed values
Message-ID: <20071219142902.GB3139@tuxdriver.com>
References: <20071219001955.055692620@polimi.it> <20071219012739.6dcdd150@morte> <20071219064510.GA18876@suse.de> <20071219102016.7785c4d3@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219102016.7785c4d3@morte>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 10:20:16AM +0100, Stefano Brivio wrote:
> On Tue, 18 Dec 2007 22:45:10 -0800
> Greg KH <gregkh@suse.de> wrote:
> 
> > On Wed, Dec 19, 2007 at 01:27:39AM +0100, Stefano Brivio wrote:

> > > here comes an implementation of debugfs_create_s{8,16,32,64} which avoids code
> > > duplication, suggested by Johannes Berg. We would need this to be merged to
> > > 2.6.25, as we need those functions to be available for rc80211-pid, the new
> > > mac80211 rate control algorithm.
> > 
> > Looks good to me, do you want me to add this to my tree and send it to
> > Linus when 2.6.25 opens up, or do you want this to go through the
> > wireless tree as you have patches relying on it?
> 
> I have one patch (rate control rework, 8/8) relying on it. Let's ask John. John,
> what's the best for you?

Since Greg approves, I'll take it through wireless-2.6 to avoid any
staging problems for patch 8/8.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
