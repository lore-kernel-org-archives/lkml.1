Return-Path: <linux-kernel-owner+w=401wt.eu-S932446AbZEAP2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbZEAP2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 11:28:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757347AbZEAP1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 11:27:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42253 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759017AbZEAP1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 11:27:50 -0400
Date: Fri, 1 May 2009 09:14:25 -0400
From: Dave Jones <davej@redhat.com>
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Nikanth Karthikesan <knikanth@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
Message-ID: <20090501131424.GA16852@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Lars Marowsky-Bree <lmb@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
	Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Nikanth Karthikesan <knikanth@suse.de>,
	"Nicholas A. Bellinger" <nab@linux-iscsi.org>,
	Kyle Moffett <kyle@moffetthome.net>,
	Bart Van Assche <bart.vanassche@gmail.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <20090501015902.ed8b56d3.akpm@linux-foundation.org> <20090501111554.GW12180@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501111554.GW12180@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 01:15:54PM +0200, Lars Marowsky-Bree wrote:
 
 > > Is it being used anywhere for anything?  If so, where and what?
 > 
 > It is used by many customers (thousands world-wide, I'm sure) to
 > replicate block device data locally (to replace more expensive SANs
 > while achieving higher availablity) or async/remotely (for disaster
 > recovery).
 > 
 > The code is rather stable, the first drbd deployments date back many
 > years - drbd0.7 for example has been shipping with SLES10/9, and 0.6
 > with SLES8 already. The new drbd8 code is shipping on SLE11 and used
 > also in combination with OCFS2.
 > 
 > So we very much welcome the renewed and persistent interest of merging
 > the code in mainline (once all serious issues are addressed).
 > 
 > Even if in the long-term a merge with other raid implementations is
 > pursued (which I'd welcome even more), the existence of so many
 > deployments means we'll need the code for awhile still.

I've not looked through the patchset, and it's a bit outside my
domain of expertise, but I can attest we have had requests to
merge it in Fedora (which we've given the usual "get it upstream" response to).
The folks who run the Fedora infrastructure have been enthusiastic
about it for a while (which is why I ended up on the CC for this thread I guess).
I don't have details about their exact use-cases, but if desired, I can
find out more.

	Dave

