Return-Path: <linux-kernel-owner+w=401wt.eu-S1761684AbYCGJhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761684AbYCGJhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763381AbYCGJgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:36:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763511AbYCGJgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:36:36 -0500
Date: Fri, 7 Mar 2008 01:35:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: linux-kernel@vger.kernel.org, menage@google.com, sukadev@us.ibm.com,
       serue@us.ibm.com, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
Message-Id: <20080307013553.7ed35f91.akpm@linux-foundation.org>
In-Reply-To: <47D10939.6020806@openvz.org>
References: <47CED717.60406@openvz.org>
	<47CEDA64.1070506@openvz.org>
	<20080305171304.f686f6de.akpm@linux-foundation.org>
	<47D10939.6020806@openvz.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Mar 2008 12:22:01 +0300 Pavel Emelyanov <xemul@openvz.org> wrote:

> > This doesn't include sufficient headers to be compileable.
> > 
> > I'm sure there are lots of headers like this.  But we regularly need
> > to fix them.
> > 
> 
> Not sure, whether this is still relevant after Greg's comments, but that's
> the -fix patch for this one. (It will cause a conflict with the 9th patch.)

Well.  Where do we stand with this?  afaict the state of play is:

Greg: do it in udev
Pavel: but people want to run old distros in containers


Realistically, when is the mainline kernel likely to have sufficient
container functionality which is sufficiently well-tested for people to
actually be able to do that?  And how much longer will it take for that
kernel.org functionality to propagate out into non-bleeding-edge distros?

Altogether we're looking at one to three years, aren't we?  By then,
perhaps a lot of "old" distros are already udev-based.

otoh, my experience upgrading old kernels to new udev has not been a
good one (ie: it didn't work).

