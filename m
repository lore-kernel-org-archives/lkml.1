Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbYIVXHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbYIVXHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 19:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYIVXHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 19:07:44 -0400
Received: from sous-sol.org ([216.99.217.87]:36026 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753146AbYIVXHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 19:07:44 -0400
X-Greylist: delayed 543 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Sep 2008 19:07:43 EDT
Date: Mon, 22 Sep 2008 15:53:21 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       James Morris <jmorris@redhat.com>, Andrew Morgan <morgan@kernel.org>,
       Andreas Gruenbacher <agruen@suse.de>, Andrew Morton <akpm@osdl.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 2/2] file capabilities: turn on by default
Message-ID: <20080922225315.GA610@sequoia.sous-sol.org>
References: <20080922184835.GA2826@us.ibm.com> <20080922184901.GA3688@us.ibm.com> <20080922120347.60a9171a.randy.dunlap@oracle.com> <20080922195647.GA25682@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922195647.GA25682@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Serge E. Hallyn (serue@us.ibm.com) wrote:
> Here are the sizes I get with Linus' plain tree and patched
> with both of these patches:
> 
> master  with file capabilities: 6241626
> master  w/o  file capabilities: 6241595
> 
> patched with file capabilities: 6241782
> patched w/o  file capabilities: 6241595
> 
> So actually I don't like the added size.

Different than I'm seeing here (note: defconfig has file capabilities):

   text	   data	    bss	    dec	    hex	filename
6804621	1017960	 671900	8494481	 819d91	obj64-defconfig/vmlinux
6804642	1017984	 671900	8494526	 819dbe	obj64-defconfig-patch/vmlinux
6804069	1017960	 671900	8493929	 819b69	obj64-nofcap/vmlinux
6804068	1017960	 671900	8493928	 819b68	obj64-nofcap-patch/vmlinux

thanks,
-chris
