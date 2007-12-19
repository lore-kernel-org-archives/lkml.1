Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbXLSJZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbXLSJZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 04:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbXLSJZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 04:25:29 -0500
Received: from mfe1.polimi.it ([131.175.12.23]:51072 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751174AbXLSJZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 04:25:27 -0500
Date: Wed, 19 Dec 2007 10:20:16 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Greg KH <gregkh@suse.de>, Johannes Berg <johannes@sipsolutions.net>,
       Mattias Nissler <mattias.nissler@gmx.de>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/8] debugfs: allow access to signed values
Message-ID: <20071219102016.7785c4d3@morte>
In-Reply-To: <20071219064510.GA18876@suse.de>
References: <20071219001955.055692620@polimi.it>
	<20071219012739.6dcdd150@morte>
	<20071219064510.GA18876@suse.de>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.311128, Antispam-Data: 2007.11.6.30824
X-PerlMx-Spam: Gauge=II, Probability=22%, Report='RELAY_IN_PBL_11 2.5, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, RELAY_IN_PBL 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2007 22:45:10 -0800
Greg KH <gregkh@suse.de> wrote:

> On Wed, Dec 19, 2007 at 01:27:39AM +0100, Stefano Brivio wrote:
> > Add debugfs_create_s{8,16,32,64}. For these to work properly, we need to remove
> > a cast in libfs.
> > 
> > Cc: Johannes Berg <johannes@sipsolutions.net>
> > To: Greg Kroah-Hartman <gregkh@suse.de>
> > Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> > ---
> > Greg,
> > 
> > here comes an implementation of debugfs_create_s{8,16,32,64} which avoids code
> > duplication, suggested by Johannes Berg. We would need this to be merged to
> > 2.6.25, as we need those functions to be available for rc80211-pid, the new
> > mac80211 rate control algorithm.
> 
> Looks good to me, do you want me to add this to my tree and send it to
> Linus when 2.6.25 opens up, or do you want this to go through the
> wireless tree as you have patches relying on it?

I have one patch (rate control rework, 8/8) relying on it. Let's ask John. John,
what's the best for you?

> Whatever works the best for you is fine for me.  If the wireless tree,
> feel free to add:
> 	Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> to the patch.

Thanks. I'm going to resend the patch to John with your Signed-off-by -- in case.


--
Ciao
Stefano
