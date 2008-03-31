Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbYCaXW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbYCaXW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 19:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYCaXWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 19:22:17 -0400
Received: from relay2.sgi.com ([192.48.171.30]:52057 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750863AbYCaXWQ (ORCPT
	<rfc822;@sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 19:22:16 -0400
Date: Tue, 1 Apr 2008 09:21:37 +1000
From: David Chinner <dgc@sgi.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>,
       Arjan van de Ven <arjan@infradead.org>,
       Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, xfs-masters@oss.sgi.com,
       xfs@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel@vger.kernel.org
Subject: Re: getting uninterruptible sleep processes after upgrade from 2.6.20.20 to 2.6.24.2
Message-ID: <20080331232137.GI103491721@sgi.com>
References: <47B892B9.7060205@allied-internet.ag> <alpine.DEB.1.00.0802172133470.6469@sheep.housecafe.de> <47B89DC6.4070906@allied-internet.ag> <20080217125407.5b76a052@laptopd505.fenrus.org> <47BD5B30.103@allied-internet.ag> <47BD7958.5080203@gmail.com> <47BD7E7F.2030603@allied-internet.ag> <47C141B9.7050001@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C141B9.7050001@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 11:06:49AM +0100, Jiri Slaby wrote:
> Ccing xfs team
> 
> On 02/21/2008 02:37 PM, Stefan Priebe - allied internet ag wrote:
> >Hello!
> >
> >I'm using XFS. dmesg -s32000 does not help - no more output. In messages 
> >there is also no relevant output. Other than what I've posted here:
> >http://lkml.org/lkml/2008/2/21/76
> 
> http://lkml.org/lkml/2008/2/21/86
> 
> Some kind of borkage in readdir, probably either in xfs or vfs?

Fixed in 2.6.24.3.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=450790a2c51e6d9d47ed30dbdcf486656b8e186f

Please upgrade.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
