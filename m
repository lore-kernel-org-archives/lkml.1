Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbZEQNLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbZEQNLf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 09:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbZEQNLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 09:11:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:48699 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbZEQNLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 09:11:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,208,1241420400"; 
   d="scan'208";a="143735582"
Date: Sun, 17 May 2009 21:11:13 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Satish Eerpini <eerpini@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Ray Lee <ray-lk@madrabbit.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: unresponsiveness on linux desktop during file copy
Message-ID: <20090517131113.GA25195@localhost>
References: <20090517020829.GB6809@localhost> <93655eb70905162130k13ebd627o5eba2582508a1c07@mail.gmail.com> <20090517045800.GA32723@localhost> <93655eb70905162318oeccafa9p76b5594f9625aefc@mail.gmail.com> <20090517093004.GA2635@localhost> <93655eb70905170501q3caf04acj761ff61b539b7d40@mail.gmail.com> <20090517121711.GA3583@localhost> <93655eb70905170527t490653dge6e25a9e3724a918@mail.gmail.com> <20090517123914.GA4221@localhost> <93655eb70905170603n50af7b7en2e2161e56ba91db9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93655eb70905170603n50af7b7en2e2161e56ba91db9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 17, 2009 at 09:03:48PM +0800, Satish Eerpini wrote:
> > Or maybe the time is spent in gnome-terminal or bash?
> > What if you change them to xterm and dash?
> >
> ok here you go , I ran "strace -o log -tt clear " on xterm and dash :
> 
> "log "

Again, it's pretty fast: 

begin with:
> 18:31:02.162301 execve("/usr/bin/clear", ["clear"], [/* 49 vars */]) = 0

end with:
> 18:31:02.167613 exit_group(0)           = ?

So the elapsed time for "clear" is about 5ms.
