Return-Path: <linux-kernel-owner+w=401wt.eu-S1765535AbXJSM1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765535AbXJSM1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 08:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbXJSM1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 08:27:04 -0400
Received: from hosted02.westnet.com.au ([203.10.1.213]:34294 "EHLO
	hosted02.westnet.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947AbXJSM1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 08:27:03 -0400
X-Greylist: delayed 1554 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Oct 2007 08:27:03 EDT
From: Mike Lampard <mike@secnet.net.au>
To: kvm-devel@lists.sourceforge.net, carsteno@de.ibm.com
Subject: Re: [kvm-devel] severe bug in 2.6.23+ kvm.git
Date: Fri, 19 Oct 2007 21:27:17 +0930
User-Agent: KMail/1.9.7
Cc: Aurelien Jarno <aurelien@aurel32.net>, Linux-kernel@vger.kernel.org
References: <47189371.7080104@de.ibm.com> <47189585.5010901@aurel32.net> <47189706.1040809@de.ibm.com>
In-Reply-To: <47189706.1040809@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710192127.17584.mike@secnet.net.au>
X-GROMMIT-SECNET-NET-AU-MailScanner: Found to be clean
X-GROMMIT-SECNET-NET-AU-MailScanner-SpamCheck: 
X-GROMMIT-SECNET-NET-AU-MailScanner-From: mike@secnet.net.au
X-STATE: 1
X-PMX-Branch: TNG-Outgoing
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 09:07:42 pm Carsten Otte wrote:
> Aurelien Jarno wrote:
> > Could you please precise what is corrupted? The guest disk image?
>
> As stated, we actually did not run any guests and did not load the kvm
> kernel modules.
> The host root file system gets corrupted to an extend not correctable
> by the file system checker (we gave it 24h to repair, then interrupted
> it), and it's very easy to reproduce: a simple kernel make on the
> hosts lets us reinstall the entire host operating system.
>
There was a commit ab9c232286c2b77be78441c2d8396500b045777e regarding libata 
on linus's master tree that happened on Friday, that was pulled into kvm git 
over the weekend.. I dont know if that may be affecting you.. there is/was 
also chatter on LKML regarding some problems with s/g, you may want to check 
there.

Cheers
Mike
