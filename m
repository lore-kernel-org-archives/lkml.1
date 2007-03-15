Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbXCPADQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbXCPADQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 20:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbXCPADP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 20:03:15 -0400
Received: from koto.vergenet.net ([210.128.90.7]:44330 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbXCPADP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 20:03:15 -0400
Date: Fri, 16 Mar 2007 08:46:16 +0900
From: Horms <horms@verge.net.au>
To: Ian Campbell <Ian.Campbell@XenSource.com>
Cc: vgoyal@in.ibm.com, hbabu@us.ibm.com, fastboot@lists.osdl.org,
       linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] Allow i386 crash kernels to handle x86_64 dumps
Message-ID: <20070315234614.GA10861@verge.net.au>
References: <1173891609.8591.41.camel@localhost.localdomain> <20070315014635.GC28396@verge.net.au> <20070315045536.GA6766@in.ibm.com> <20070315050754.GB22329@verge.net.au> <20070315054726.GC6766@in.ibm.com> <1173961378.8591.63.camel@localhost.localdomain> <20070315132616.GH6766@in.ibm.com> <1173966159.8591.82.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173966159.8591.82.camel@localhost.localdomain>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 01:42:39PM +0000, Ian Campbell wrote:
> On Thu, 2007-03-15 at 18:56 +0530, Vivek Goyal wrote:
> > 
> > Ideal place for this probably should have been arch dependent
> > crash_dump.h file. But we don't have one and no point introducing one
> > just for this  macro.
> 
> Agreed.
> 
> > This change looks good to me. 
> 
> Is there a kdump tree which you'll apply to or shall I resend CCing
> apkm? (I'll add an Acked-by if that's ok).

There isn't a kexec tree at this time (though I am happy to entertain
creating one). For now most patches go in either through Andrew or the
relevant architecture maintainers.

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

