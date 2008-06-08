Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbYFHBTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbYFHBTk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 21:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbYFHBT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 21:19:28 -0400
Received: from swan.nt.tuwien.ac.at ([128.131.67.158]:46207 "EHLO
	swan.nt.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407AbYFHBT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 21:19:27 -0400
X-Greylist: delayed 626 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Jun 2008 21:19:27 EDT
Date: Sun, 8 Jun 2008 03:08:58 +0200
From: Thomas Zeitlhofer <tzeitlho+lkml@nt.tuwien.ac.at>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Subject: IPSEC in 2.6.25 causes stalled connections
Message-ID: <20080608010858.GA8877@swan.nt.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have two machines (x86_64) connected via a direct network link (i.e.
directly connected by cable).

IPSEC is used for all traffic over this link. 

Everything works fine as long as the traffic is low. E.g. several
interactive ssh sessions are ok.

If a TCP or UDP connection (e.g. cat /dev/zero | netcat [-u] ...)
produces a lot of traffic then this connection typically stalls within
a couple minutes. Some but not all of the other open connections (e.g.
ssh sessions) get stuck too. The stalled connections do not recover and
the ssh sessions finally terminate with a timeout error.

This happens with 2.6.25.4 (also tested with 2.6.25) and IPSEC. Without
IPSEC there is no problem with stalled connections.

The problem also goes away if I switch back to 2.6.24.4.

Is this a known issue?

Thanks,

Thomas
