Return-Path: <linux-kernel-owner+w=401wt.eu-S933765AbXBZEfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765AbXBZEfe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 23:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933766AbXBZEfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 23:35:34 -0500
Received: from fall-curlleaf.atl.sa.earthlink.net ([207.69.195.105]:58131 "EHLO
	fall-curlleaf.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933765AbXBZEfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 23:35:33 -0500
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Feb 2007 23:35:33 EST
Subject: Re: [kvm-devel] PIO port width on various archs?
From: Hollis Blanchard <hollis@penguinppc.org>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <45E14F9D.3050502@qumranet.com>
References: <45E14F9D.3050502@qumranet.com>
Content-Type: text/plain
Date: Sun, 25 Feb 2007 22:27:47 -0600
Message-Id: <1172464067.12245.4.camel@diesel>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-25 at 10:58 +0200, Avi Kivity wrote:
> I'm changing the kvm userspace interface to be more friendly to other 
> archs.  One issue is the PIO port size.  x86 uses 16 bits to hold the 
> port size (64K ports).  Is that an issue for other archs?
> 
> I guess I could change it to __u32, but it's better to know what various 
> architectures actually require.

PowerPC doesn't have any such concept; access to ISA PIO is done by
having the bridge translate a particular range of MMIO accesses as PIO.
I'm no expert, but I don't know of any mainstream processor other than
x86 that supports PIO.

-Hollis

