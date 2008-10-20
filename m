Return-Path: <linux-kernel-owner+w=401wt.eu-S1758479AbYJTRXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbYJTRXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbYJTRRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:17:19 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37675 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756381AbYJTRRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:17:18 -0400
Subject: Re: [RFC v6][PATCH 0/9] Kernel based checkpoint/restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Newall <davidn@davidnewall.com>
Cc: Peter Chubb <peterc@gelato.unsw.edu.au>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       jeremy@goop.org, arnd@arndb.de, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andrey Mirkin <major@openvz.org>
In-Reply-To: <48F83121.7070705@davidnewall.com>
References: <1223461197-11513-1-git-send-email-orenl@cs.columbia.edu>
	 <20081009124658.GE2952@elte.hu>	<1223557122.11830.14.camel@nimitz>
	 <20081009131701.GA21112@elte.hu>	<1223559246.11830.23.camel@nimitz>
	 <20081009134415.GA12135@elte.hu>	<1223571036.11830.32.camel@nimitz>
	 <20081010153951.GD28977@elte.hu>	<48F30315.1070909@fr.ibm.com>
	 <1223916223.29877.14.camel@nimitz>	<48F6092D.6050400@fr.ibm.com>
	 <48F685A3.1060804@cs.columbia.edu>	<48F7352F.3020700@fr.ibm.com>
	 <48F74674.20202@cs.columbia.edu> <87r66g8875.wl%peter@chubb.wattle.id.au>
	 <48F83121.7070705@davidnewall.com>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 10:17:12 -0700
Message-Id: <1224523032.1848.119.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-17 at 17:00 +1030, David Newall wrote:
> > The strace/gdb example is *really* hard; but for vfork, you just wait
> > until it's over. The interval between vfork and exec/exit should be
> > short enough not to affect the overall time for a checkpoint
> 
> A malicious user could trivially exploit that.

You mean a malicious user could prevent a checkpoint from occurring by
doing this?

There are going to be a lot of those for a long while. :)

-- Dave

