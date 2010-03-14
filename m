Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab0CNGzg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 01:55:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:42756 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab0CNGze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 01:55:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LhKTpNJ99fgfK+llZn/13w0iNxvwjgPDy6B46crpvFBTeMZk8jSnt1A6ls8rvjEQmd
         OGO9A9+NKjyQZWBzHGNeu/sf58fMQVYFocVV9pVHdMhkuwVpv556RHGu+6WQ1be0e2eF
         S0NLADhC38z6YXlsXpZwriPm7YeQMJTLdUdCU=
Date: Sun, 14 Mar 2010 08:55:26 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Subject: Re: 2.6.34-rc1: Badness at fs/proc/generic.c:316
Message-ID: <20100314065526.GA5353@x200>
References: <alpine.DEB.2.01.1003131544340.5493@bogon.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1003131544340.5493@bogon.housecafe.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 03:53:28PM -0800, Christian Kujau wrote:
> after upgrading from 2.6.33 to today's latest mainline (daf9fe2...), I'm 
> getting this during bootup on a powerpc machine (Powerbook G4):
> 
> [    0.002187] ------------[ cut here ]------------
> [    0.002197] Badness at fs/proc/generic.c:316

> device-tree: Duplicate name in /cpus/PowerPC,G4@0, renamed to "l2-cache#1"
> name 'pulses/rev'

Uh-oh.

> Is this something to worry about? The machine seems to run fine so far...

Runtime behaviour remains the same, it's just new warning message.
