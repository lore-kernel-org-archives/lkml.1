Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbZEALQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbZEALQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 07:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbZEALQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 07:16:06 -0400
Received: from gate.in-addr.de ([212.8.193.158]:35118 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752645AbZEALQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 07:16:05 -0400
Date: Fri, 1 May 2009 13:15:54 +0200
From: Lars Marowsky-Bree <lmb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
Message-ID: <20090501111554.GW12180@suse.de>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <20090501015902.ed8b56d3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090501015902.ed8b56d3.akpm@linux-foundation.org>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-05-01T01:59:02, Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 30 Apr 2009 13:26:36 +0200 Philipp Reisner <philipp.reisner@linbit.com> wrote:
> 
> > This is a repost of DRBD
> How fast is it?

>From experience, it achieves performance of approx. 98% of wire or
spindle speed, so it is considered rather efficient code.

> Is it being used anywhere for anything?  If so, where and what?

It is used by many customers (thousands world-wide, I'm sure) to
replicate block device data locally (to replace more expensive SANs
while achieving higher availablity) or async/remotely (for disaster
recovery).

The code is rather stable, the first drbd deployments date back many
years - drbd0.7 for example has been shipping with SLES10/9, and 0.6
with SLES8 already. The new drbd8 code is shipping on SLE11 and used
also in combination with OCFS2.

So we very much welcome the renewed and persistent interest of merging
the code in mainline (once all serious issues are addressed).

Even if in the long-term a merge with other raid implementations is
pursued (which I'd welcome even more), the existence of so many
deployments means we'll need the code for awhile still.


Regards,
    Lars

-- 
SuSE Labs, OPS Engineering, Novell, Inc.
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

