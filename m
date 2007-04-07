Return-Path: <linux-kernel-owner+w=401wt.eu-S965442AbXDGHPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965442AbXDGHPo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 03:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965449AbXDGHPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 03:15:44 -0400
Received: from 1wt.eu ([62.212.114.60]:1698 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965442AbXDGHPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 03:15:43 -0400
Date: Sat, 7 Apr 2007 09:15:35 +0200
From: Willy Tarreau <w@1wt.eu>
To: johnrobertbanks@fastmail.fm
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
Message-ID: <20070407071535.GD943@1wt.eu>
References: <461592FB.5060507@zytor.com> <1175819681.20754.1183287946@webmail.messagingengine.com> <461596DE.2020802@zytor.com> <1175823288.25662.1183293506@webmail.messagingengine.com> <4615C780.5040407@zytor.com> <1175833931.8916.1183307802@webmail.messagingengine.com> <20070406152119.GC4228@delft.aura.cs.cmu.edu> <1175914056.9653.1183426876@webmail.messagingengine.com> <20070407033049.GI4228@delft.aura.cs.cmu.edu> <1175925525.21154.1183436614@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175925525.21154.1183436614@webmail.messagingengine.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 10:58:45PM -0700, johnrobertbanks@fastmail.fm wrote:
> You know,... you cut out this bit:
> 
> -----------------------------------------------------------------
> 
> > The following benchmarks are from
> > 
> > http://linuxhelp.150m.com/resources/fs-benchmarks.htm or,
> > http://m.domaindlx.com/LinuxHelp/resources/fs-benchmarks.htm

...

Hey John, please change your disk, it's scratched and you're repeating
yourself again and again. At first I thought "Oh cool, some good news
about reiser4", now when I see "reiserfs" in a thread, I think "oh no,
not this boring guy who escaped from the asylum again !". I hope this
thread will be cut shortly so that you stop doing bad publicity to
reiserfs and its developers, because when a product is indicated as
good by stupid people, it's really doing harm.

Also, about this part :
[Jan]
> > But in the end everything is a tradeoff. You can save diskspace, but
> > increase the cost of corruption. 

I don't 100% agree with Jan, because for some usages (temporary space),
light compression can increase speed. For instance, when processing logs,
I get better speed by compressing intermediate files with LZO on the fly.

[John]
> You deliberately ignored the fact that bad blocks are NOT dealt with by
> the filesystem,... but by the operating system. Like I said: If your
> filesystem is writing to bad blocks, then throw away your operating
> system.

But what you write here is complete crap. The filesystem relies on a
linear block device. The operating system is responsible for doing
read retries or reporting errors on bad blocks, but the FS and only
the FS can decide how not to use some known defective areas, for
instance not putting any metadata on them nor any useful data.

Now if you want to stop writing stupid things again and again, take
your bag, don't miss the bus to school, and listen to the teachers
instead of playing games on your calculator.

Willy
PS: non need to reply either, I'll kill this thread and your address here.

