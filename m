Return-Path: <linux-kernel-owner+w=401wt.eu-S1751991AbYJNNny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbYJNNny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 09:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbYJNNnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 09:43:45 -0400
Received: from moog.chdir.org ([88.191.42.160]:55618 "EHLO moog.chdir.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbYJNNnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 09:43:45 -0400
Date: Tue, 14 Oct 2008 15:43:41 +0200
From: Nicolas Bareil <nico@chdir.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Nicolas Bareil <nico@chdir.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: USB problem on x86_64: nommu_map_single() issue?
Message-ID: <20081014134341.GA2196@sd-5945.dedibox.fr>
References: <20081014072045.GA1252@sd-5945.dedibox.fr> <200810141148.48220.oliver@neukum.org> <20081014104500.GB1252@sd-5945.dedibox.fr> <200810141300.29502.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810141300.29502.oliver@neukum.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 01:00:28PM +0200, Oliver Neukum wrote:
> > Yes this is a regression: USB works in 2.6.26.x with (almost) the same configuration.
> 
> This a an IOMMU problem, not really a USB problem. Can you bisect the problem?

Ok, after 24 reboots, I have the following commit:

commit 6f21d806f698a5c437dcae1f03e8dd73e3f5aab1
Merge: e59e14b... 9f72632...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Sep 21 12:40:56 2008 -0700

    Merge branch 'kvm-updates/2.6.27' of git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm

    * 'kvm-updates/2.6.27' of git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm:
      KVM: ia64: 'struct fdesc' build fix

Do you think I'm good to bisect that tree or do you have an idea?

