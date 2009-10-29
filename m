Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbZJ2AaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbZJ2AaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 20:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbZJ2AaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 20:30:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:38181 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981AbZJ2AaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 20:30:13 -0400
Date: Wed, 28 Oct 2009 17:27:18 -0700
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: Milan Dadok <milan@dadok.name>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH] 3/3 staging: hv: fix oops in vmbus - missing #include
Message-ID: <20091029002718.GA18047@suse.de>
References: <001601ca581d$5390e0e0$fab2a2a0$@name>
 <20091028223114.GA25962@suse.de>
 <001701ca5821$8a52aec0$9ef80c40$@name>
 <20091028230120.GB15420@suse.de>
 <8AFC7968D54FB448A30D8F38F259C5620E7EEC5C@TK5EX14MBXC114.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C5620E7EEC5C@TK5EX14MBXC114.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 12:14:34AM +0000, Hank Janssen wrote:
> 
> 
> >> On Wed, Oct 28, 2009 at 4:01 PM, Greg KH wrote:
> >>On Wed, Oct 28, 2009 at 11:54:00PM +0100, Milan Dadok wrote:
> > drivers/staging/hv/osd.h:68: warning: its scope is only this definition or
> > declaration, which is probably not what you want
> >
> >Wierd.  Can you send me your .config file?  I can't duplicate this on
> >Linus's current git tree at all.
> 
> Can you forward me your config as well Milan? I am running of Linus latest
> Git tree and it works just fine without the include in osd.h. There should be
> No reason to have the include in osd.h.

Milan sent it to me off-list, and with Linus's latest tree, I can
duplicate this.  I'll queue up his patch.

thanks,

greg k-h
