Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbZEQMRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbZEQMRc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 08:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbZEQMRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 08:17:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:8024 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbZEQMRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 08:17:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,207,1241420400"; 
   d="scan'208";a="143724160"
Date: Sun, 17 May 2009 20:17:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Satish Eerpini <eerpini@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Ray Lee <ray-lk@madrabbit.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: unresponsiveness on linux desktop during file copy
Message-ID: <20090517121711.GA3583@localhost>
References: <2c0942db0905160903i5517d3d6l50fc7457a2629694@mail.gmail.com> <4A0EFA08.4060106@redhat.com> <20090517011906.GA6375@localhost> <93655eb70905161827x34a432ebn4910ee86d9bae30@mail.gmail.com> <20090517020829.GB6809@localhost> <93655eb70905162130k13ebd627o5eba2582508a1c07@mail.gmail.com> <20090517045800.GA32723@localhost> <93655eb70905162318oeccafa9p76b5594f9625aefc@mail.gmail.com> <20090517093004.GA2635@localhost> <93655eb70905170501q3caf04acj761ff61b539b7d40@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <93655eb70905170501q3caf04acj761ff61b539b7d40@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 17, 2009 at 08:01:29PM +0800, Satish Eerpini wrote:
> > Hmm, how do you define/feel the unresponsiveness?  Is it related to
> > the currently *running* applications, or opening a *new* application?
> 
> the unresponsiveness is for both the currently running applications
> and for opening new applications, here are some pointers :
> 
> --> during normal operation, swtiching between windows( alt+tab) is
> simultaneous, while during a file copy it takes around 1 second, which
> I think is quite a lag.
> --> Opening a simple application like gnome-terminal takes a second or
> more for sure when there is a file copy going on.
> -->Also a particular window after gaining focus takes a second or so,
> to resume what it was doing, .. so if I am copying a file in a session
> of gnome-terminal and open another session of gnome-terminal and type
> in "clear" it takes around 2 seconds before the screen is cleared on
> the second session,

The clear command can be a big clue. Can you try these commands in the
terminal and show us the two log files?

        strace -o all.log -T clear
        strace -o sum.log -c clear

> this is the case with almost every application and worser with big
> ones like firefox and office. This was the kind of unresponsiveness I
> was talking about.
> 
> Cheers
> Satish
> -- 
> http://satish.playdrupal.com
