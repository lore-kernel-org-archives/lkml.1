Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZBCPL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZBCPL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 10:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbZBCPLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 10:11:48 -0500
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:60409 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbZBCPLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 10:11:48 -0500
X-Greylist: delayed 510 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Feb 2009 10:11:48 EST
Date: Tue, 3 Feb 2009 16:03:15 +0100
From: Gabor Gombas <gombasg@sztaki.hu>
To: "Daniel P. Berrange" <berrange@redhat.com>
Cc: debian-devel@lists.debian.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: cgroup mount point
Message-ID: <20090203150315.GI482@boogie.lpds.sztaki.hu>
References: <20090202200013.GU3643@vespa.holoscopio.com> <1233606371.15779.32.camel@radis.liafa.jussieu.fr> <20090202205246.GA28593@glandium.org> <20090202214153.GV3643@vespa.holoscopio.com> <20090203102416.GA8886@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203102416.GA8886@redhat.com>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 10:24:16AM +0000, Daniel P. Berrange wrote:

> Putting new mount points in / is not really acceptable, so that rules
> out the first two. /opt is just totally wrong, since that is intended
> for add on software packages. /dev/ feels a little odd, since it is
> not really device nodes, but perhaps that doesn't matter. So my pref
> would be something in /dev/cgroups or /sys/cgroups

How about /var/lib/cgroup? There's already precedent
(/var/lib/nfs/rpc_pipefs) of mounting virtual file systems under
/var/lib.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
