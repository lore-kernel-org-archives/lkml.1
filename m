Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbZDIGGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbZDIGGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 02:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbZDIGFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 02:05:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59798 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454AbZDIGFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 02:05:50 -0400
From: Neil Brown <neilb@suse.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 9 Apr 2009 16:05:55 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18909.36931.482484.941387@notabene.brown>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] sysfs poll should keep the poll rule of normal regular file.
In-Reply-To: message from KOSAKI Motohiro on Thursday April 9
References: <20090408173935.8D7E.A69D9226@jp.fujitsu.com>
	<18909.15904.704697.734477@notabene.brown>
	<20090409092302.8D8A.A69D9226@jp.fujitsu.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday April 9, kosaki.motohiro@jp.fujitsu.com wrote:
> > On Wednesday April 8, kosaki.motohiro@jp.fujitsu.com wrote:
> > > Because Ruby (the scripting language) VM assume select system-call against regular file don't block.
> > > (POSIX gurantee it.)
> > > But sysfs_poll() don't keep this rule although sysfs file can read and write always.
> > 
> > It would be nice to include a reference to where POSIX (or SUS)
> > guarantees it - though I suspect you are right.
> 
> Oh, very good opinion.
> 
> following explanation is better?
> 
> poll is requireed "Regular files shall always poll TRUE for reading and
> writing." by SUSv3.
>   see http://www.opengroup.org/onlinepubs/009695399/functions/poll.html
> 

Yes, that's excellent, thanks.

NeilBrown
