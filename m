Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbZAIDaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbZAIDaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 22:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZAIDah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 22:30:37 -0500
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:41298 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751811AbZAIDag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 22:30:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiIHALVRZklMQWjN/2dsb2JhbACBbJJ+ul2FdQ
Date: Thu, 8 Jan 2009 22:30:22 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Greg KH <gregkh@suse.de>
Subject: Re: [ltt-dev] [PATCH 1/2] Make lttctl mount debugfs automatically
Message-ID: <20090109033021.GA25504@Krystal>
References: <49646208.7070607@cn.fujitsu.com> <4964BA2B.30200@polymtl.ca> <AA3F776E5F6246859F1978B7C7CF1919@zhaoleiwin> <20090108144430.GA3778@Krystal> <7C0A417AB5B84CDCB9A9484C4E13A08C@zhaoleiwin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <7C0A417AB5B84CDCB9A9484C4E13A08C@zhaoleiwin>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:28:15 up 8 days,  3:26,  2 users,  load average: 0.13, 0.16,
	0.13
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Zhaolei (zhaolei@cn.fujitsu.com) wrote:
> * From: "Mathieu Desnoyers" <compudj@krystal.dyndns.org>
> >* Zhaolei (zhaolei@cn.fujitsu.com) wrote:
> >> * From: "Pierre-Marc Fournier" <pierre-marc.fournier@polymtl.ca>
> >> > Zhaolei wrote:
> >> >> lttctl need debugfs mounted,
> >> >> This patch make lttctl mount debugfs automatically when it is not mounted.
> >> >> 
> >> > 
> >> > Isn't having a utility such as lttctl mount filesystems against standard
> >> > unix semantics? Can you give an example of another standard command that
> >> > uses a filesystem and that tries to mount it if it isn't already
> >> > mounted? 
> >> Hello, Pierre-Marc,
> >> 
> >> I can give a an example.
> >> It is SystemTap.
> >> 
> > 
> > No offence, but can you find an example which is not explicitly
> > described as "bad taste" example by many people in the Linux kernel
> > community ?
> Hello, Mathieu
> 
> I can't find another example of mounting debugfs automatically.
> Maybe it is because debugfs is not widely used as others such as sysfs and
> procfs.
> 
> sysfs and procfs are mounted in boot, and user-mode tools need not check and
> mount then again. But debugfs is not too useful for normal user who just use
> linux to edit text and browse internet, so mount debugfs in boot period is not
> a good idea.
> So, IMHO, debugfs's usage is not same as sysfs and procfs, we need not mount
> sysfs and procfs in user-mode program, but maybe it is different for debugfs.
> 
> On the other hand, I also understand your opinion, mount a fs in program looks
> strange(but can make user easy to use...), so you can feel free to ignore this
> patch.
> Same with [PATCH 2/2] Make lttctl load ltt-trace-control module automatically.
> 

I wonder what's Greg KH (and others) opinion about this ?

Mathieu


> Regards
> Zhaolei
> 
> > 
> > Mathieu
> > 
> >> Regards
> >> Zhaolei
> >> 
> >> > My guess is we should warn about the filesystem not being
> >> > mounted, but not try to call mount() directly.
> >> > 
> >> >> Little cleanup also done(combile 2 getdebugfsmntdir() into one).
> >> >> 
> >> >> Applies on top of ltt-control-0.63-03012009.
> >> >> 
> >> > 
> >> >
> >> _______________________________________________
> >> ltt-dev mailing list
> >> ltt-dev@lists.casi.polymtl.ca
> >> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> >> 
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > 
> >
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
