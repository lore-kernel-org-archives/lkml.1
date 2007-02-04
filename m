Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579AbXBDWmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbXBDWmB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 17:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbXBDWmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 17:42:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbXBDWmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 17:42:00 -0500
Date: Sun, 4 Feb 2007 17:39:42 -0500
From: Dave Jones <davej@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric Piel <Eric.Piel@tremplin-utc.net>,
       Wang Zhenyu <zhenyu.z.wang@intel.com>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.20-rc7 regression on intel-agp
Message-ID: <20070204223942.GA8960@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Eric Piel <Eric.Piel@tremplin-utc.net>,
	Wang Zhenyu <zhenyu.z.wang@intel.com>, linux-kernel@vger.kernel.org,
	Adrian Bunk <bunk@stusta.de>
References: <45C6010A.9010902@tremplin-utc.net> <20070204171850.GA17171@redhat.com> <45C64960.3080605@tremplin-utc.net> <20070204130846.d8895f97.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070204130846.d8895f97.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 04, 2007 at 01:08:46PM -0800, Randy Dunlap wrote:
 > On Sun, 04 Feb 2007 22:00:16 +0100 Eric Piel wrote:
 > 
 > > 04.02.2007 18:18, Dave Jones wrote/a écrit:
 > > > On Sun, Feb 04, 2007 at 04:51:38PM +0100, Eric Piel wrote:
 > > >  > Hello,
 > > >  > 
 > > >  > I've got a regression in 2.6.20-rc7 (-rc6 was fine) due to commit 
 > > >  > 4b95320fc4d21b0ff2f8604305dd6c851aff6096 ([AGPGART] intel_agp: restore 
 > > >  > graphics device's pci space early in resume).
 > > :
 > > > 
 > > > There's an ugly patch below which does the latter. Give it a try?
 > > Thanks a lot, this made the trick... to some extends at least. I can 
 > > suspend to disk and resume fine. The framebuffer is not garble neither, 
 > > however nothing is displayed after resuming :-S Well, it's probably 
 > > enough to be applied before 2.6.20.
 > 
 > Missed that.  Please send it to stable@kernel.org .

Done.  It's also in agpgart.git, waiting for Linus to pull when
he's ready to open the floodgates for .21 again.

		Dave

-- 
http://www.codemonkey.org.uk
