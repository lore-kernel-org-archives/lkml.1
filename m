Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbZHMTTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbZHMTTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbZHMTTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:19:06 -0400
Received: from kroah.org ([198.145.64.141]:34685 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509AbZHMTTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:19:05 -0400
Date: Thu, 13 Aug 2009 12:16:25 -0700
From: Greg KH <greg@kroah.com>
To: Artur Skawina <art.08.09@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: xterm loses data (pts regression?)
Message-ID: <20090813191625.GA11886@kroah.com>
References: <4A800068.7030401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A800068.7030401@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 01:11:36PM +0200, Artur Skawina wrote:
> First noticed it after upgrading to v2.6.31-rc5-246-g90bc1a6, still happens
> in rc5-381-g7b2aa03.
> If i press ^S in an xterm the output stops as expected, but after a ^Q i see
> only the newly written data, everything in between is lost. Like:
> 
> > for i in `seq 1 111`; do echo $i; sleep 1; done
> 1
> 2
> 3
> 4
> 9
> 10
> 11
> 12
> 13
> ^C
> 
> [typed ^S after '4', then ^Q after a few seconds]
> 
> If the command doing the printing exits before the ^Q is sent, i don't get
> any reaction to the ^Q at all, which is why i initially thought it to be an
> xserver bug.
> Text consoles are unaffected, output resumes as it should.

This should now be fixed in Linus's tree by:
	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=85dfd81dc57e8183a277ddd7a56aa65c96f3f487

if not, please let us know.

thanks,

greg k-h
