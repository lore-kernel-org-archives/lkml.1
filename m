Return-Path: <linux-kernel-owner+w=401wt.eu-S1762808AbXLPVxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762808AbXLPVxn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 16:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760238AbXLPVxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 16:53:34 -0500
Received: from mail.gmx.net ([213.165.64.20]:39296 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758784AbXLPVxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 16:53:32 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1+kTQZ0+IWkkSr6QEn3efHmOB5qkVZcarCYoURoCm
	o2KAtbgGrQJsov
From: Helge Deller <deller@gmx.de>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [e2fsprogs PATCH] Userspace solution to time-based UUID without duplicates
Date: Sun, 16 Dec 2007 22:53:19 +0100
User-Agent: KMail/1.9.7
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>
References: <200711182038.22055.deller@gmx.de> <20071120230012.GF26022@thunk.org> <20071210053604.GF17037@thunk.org>
In-Reply-To: <20071210053604.GF17037@thunk.org>
X-Face: &[jmHH-Dw>Aj):"[/t-VasJu+(5eP`/LEckV7V"JV,!nBy[6(/?#8M>x`5xzg/7:FkM.l@=?utf-8?q?=0A=0913?=<&9'nfV3"OkD~P)@j{P2=(uB7J(){:CcrM2jZeA+IBq?FUTp3c8Y{t+k<95mZf~[v"=?utf-8?q?=27=3A=0A=09t?="f6wKtHUPFB&/]Z5^?9~IQs=16R;Pg"NS9JD=DK!ft&4b@=?utf-8?q?S=7E=26q/MfI3=3BqWqlg7Q1=3D=3DjS4=0A=099V5OJkm=24WQ=5Bdc=5E=5FY?=
 =?utf-8?q?=27=5DDvibvMjizUZ=5D+=27Jd4UnM?=><yrT}Rw(
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712162253.20928.deller@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 December 2007, Theodore Tso wrote:
> On Tue, Nov 20, 2007 at 06:00:12PM -0500, Theodore Tso wrote:
> > Basically, the only way to solve this problem 100% in userspace would
> > be with a userspace daemon running as a privileged user, and some kind
> > of Unix domain socket.
> > 
> > Patches to implement this in the e2fsprogs UUID library would be
> > greatfully accepted.
> 
> This patch creates a userspace uuidd which correctly generates
> time-based (version 1) UUID's, with the clock sequence number stored
> in the filesystem so we correctly detect time going backwards across
> processes and even across reboots.
> 
> I believe this patch is a better solution than Helge's kernel patch
> solution or the kludgy patch to e2fsprogs in the the SLES RPM which
> tries to solve this problem in another way, but which has been
> problematic in the past.
> 
> Helge, could you try this out and see if it meets your needs?
> 
> (Ted's patch to e2fsprogs removed here)

FYI, we are currently discussing and testing this proposed patch to e2fsprogs off-list in Red Hat's bugzilla:
https://bugzilla.redhat.com/show_bug.cgi?id=233471

Helge
