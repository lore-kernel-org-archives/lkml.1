Return-Path: <linux-kernel-owner+w=401wt.eu-S1752109AbXCPIin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbXCPIin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbXCPIin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:38:43 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:1303 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbXCPIim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:38:42 -0400
Date: Fri, 16 Mar 2007 09:36:50 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 0/15] KVM userspace interface updates
Message-ID: <20070316083650.GA8525@osiris.boeblingen.de.ibm.com>
References: <11736212072915-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11736212072915-git-send-email-avi@qumranet.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2007 at 03:53:12PM +0200, Avi Kivity wrote:
> This patchset updates the kvm userspace interface to what I hope will
> be the long-term stable interface.  Provisions are included for extending
> the interface later.  The patches address performance and cleanliness
> concerns.

Searching the mailing list I figured that as soons as the interface seems
to be stable, kvm should/would switch to a system call based interface.
I assume the userspace interface might still change a lot, especially if
kvm is ported to new architectures.
But the general question is: do you still plan to switch to a syscall
interface?
