Return-Path: <linux-kernel-owner+w=401wt.eu-S1762342AbZAPJFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762342AbZAPJFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 04:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974AbZAPJFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 04:05:13 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:57497 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755049AbZAPJFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 04:05:09 -0500
Date: Fri, 16 Jan 2009 18:02:11 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Greg KH <greg@kroah.com>
Cc: Trilok Soni <soni.trilok@gmail.com>, Arve Hj?nnev?g <arve@android.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       Brian Swetland <swetland@google.com>, arve@google.com,
       San Mehat <san@android.com>, Robert Love <rlove@google.com>,
       linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       ext Juha Yrj?l? <juha.yrjola@solidboot.com>, viktor.rosendahl@nokia.com
Subject: Re: lowmemory android driver not needed?
Message-ID: <20090116090210.GB7039@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Greg KH <greg@kroah.com>, Trilok Soni <soni.trilok@gmail.com>,
	Arve Hj?nnev?g <arve@android.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
	Brian Swetland <swetland@google.com>, arve@google.com,
	San Mehat <san@android.com>, Robert Love <rlove@google.com>,
	linux-kernel@vger.kernel.org,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	ext Juha Yrj?l? <juha.yrjola@solidboot.com>,
	viktor.rosendahl@nokia.com
References: <d6200be20901131830r7103ff8eoe0314f9faf89d89b@mail.gmail.com> <20090114035237.GB16442@kroah.com> <20090114104307.GA20451@elf.ucw.cz> <20090114104834.18387fca@lxorguk.ukuu.org.uk> <d6200be20901141426r1d48ea33gc9a380451e4aaf93@mail.gmail.com> <20090114231739.GB24111@kroah.com> <d6200be20901141532y6f236104kd521041d640c152e@mail.gmail.com> <20090115001224.GC11328@kroah.com> <5d5443650901150532r20a4c25q834afadde2f98a3@mail.gmail.com> <20090115234404.GA20142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115234404.GA20142@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 03:44:04PM -0800, Greg KH wrote:
> On Thu, Jan 15, 2009 at 07:02:48PM +0530, Trilok Soni wrote:
> > And there is one more lowmem driver developed by Nokia for Nokia 8xx
> > tablets it seems. CCed Tony Lindgren,  Juha and Viktor.
> > 
> > http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap-2.6.git;a=blob;f=security/lowmem.c;h=ae78a530af39703e335ad769f1e6f097f63ec6dd;hb=HEAD
> 
> As we can't stack LSMs, using the lsm interface for a simple memory
> driver seems pretty wasteful :)
> 
The heuristics and tunables are more what ended up being useful with this
module, which could trivially be abstracted out. The focus of the lowmem
module was mostly giving userspace an opportunity to change its behaviour,
and to try to save critical state. I don't know how well this would map
to the Android use cases, though.
