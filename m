Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbZBCQVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbZBCQVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbZBCQVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:21:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42190 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbZBCQVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:21:02 -0500
Date: Tue, 3 Feb 2009 11:19:49 -0500
From: Bill Nottingham <notting@redhat.com>
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: "Daniel P. Berrange" <berrange@redhat.com>, debian-devel@lists.debian.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: cgroup mount point
Message-ID: <20090203161949.GB32677@nostromo.devel.redhat.com>
Mail-Followup-To: Gabor Gombas <gombasg@sztaki.hu>,
	"Daniel P. Berrange" <berrange@redhat.com>,
	debian-devel@lists.debian.org, linux-kernel@vger.kernel.org,
	containers@lists.linux-foundation.org
References: <20090202200013.GU3643@vespa.holoscopio.com> <1233606371.15779.32.camel@radis.liafa.jussieu.fr> <20090202205246.GA28593@glandium.org> <20090202214153.GV3643@vespa.holoscopio.com> <20090203102416.GA8886@redhat.com> <20090203150315.GI482@boogie.lpds.sztaki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203150315.GI482@boogie.lpds.sztaki.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabor Gombas (gombasg@sztaki.hu) said: 
> On Tue, Feb 03, 2009 at 10:24:16AM +0000, Daniel P. Berrange wrote:
> 
> > Putting new mount points in / is not really acceptable, so that rules
> > out the first two. /opt is just totally wrong, since that is intended
> > for add on software packages. /dev/ feels a little odd, since it is
> > not really device nodes, but perhaps that doesn't matter. So my pref
> > would be something in /dev/cgroups or /sys/cgroups
> 
> How about /var/lib/cgroup? There's already precedent
> (/var/lib/nfs/rpc_pipefs) of mounting virtual file systems under
> /var/lib.

Depending on when you need the cgroup filesystem to setup your
containers, /var may not be there.

Bill
