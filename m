Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbZFBQFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbZFBQFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 12:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZFBQFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 12:05:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46181 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbZFBQFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 12:05:30 -0400
Date: Tue, 2 Jun 2009 19:04:34 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com
Subject: Re: [KVM-RFC PATCH 0/2] irqfd: use POLLHUP notification for close()
Message-ID: <20090602160434.GA6827@redhat.com>
References: <20090602151135.29746.91320.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602151135.29746.91320.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 11:15:28AM -0400, Gregory Haskins wrote:
> (Applies to kvm.git/master:25deed73)
> 
> Please see the header for 2/2 for a description.  This patch series has
> been fully tested and appears to be working correctly.  I have it as an RFC
> for now because it needs Davide's official submission/SOB for patch 1/2, and
> it should get some eyeballs/acks on my SRCU usage before going in.
> 
> I will submit the updated irqfd userspace which eschews the deassign() verb
> since we can now just use the close(fd) method alone.  I will also address
> the userspace review comments from Avi.


We are not killing the deassign though, do we?
It's good to have that option e.g. for when we pass
the fd to another process.

-- 
MST
