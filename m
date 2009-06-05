Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbZFESxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbZFESxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbZFESxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:53:24 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:38868 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbZFESxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:53:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=Ax4+mGglaoHZQXcFsDF2Z18UDlZ6xTWtIWDKz1rRg+SHvl9FY851SyoxOxbQH1utem
         8ov9B4+fB4JQSWu96OeyLMOaHBZD06VV7Pz/vTdH37mYpzfGtXZ1U9J+eRV6xOAdtLBw
         KwNAfzurjq/g3CqcS+KdRZSUDID7BAWXrgbCo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Gao, Yunpeng" <yunpeng.gao@intel.com>
Subject: Re: linux-next: Tree for June 3 (staging)
Date: Fri, 5 Jun 2009 20:58:19 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc8-next-20090604-07237-g030af10; KDE/4.2.3; i686; ; )
Cc: Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au> <20090604175219.GA18605@kroah.com> <38D9F46DFF92C54980D2F2C1E8EE313001A45F49F3@pdsmsx503.ccr.corp.intel.com>
In-Reply-To: <38D9F46DFF92C54980D2F2C1E8EE313001A45F49F3@pdsmsx503.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906052058.19875.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 June 2009 05:31:21 Gao, Yunpeng wrote:
> Hi Greg,
> 
> Thanks for your quick response.
> 
> The root cause of the build-errors in ffsport.c is that the kernel block layer APIs are different in linux-next tree (.../linux/kernel/git/sfr/linux-next.git) than in Linus' kernel tree (.../linux/kernel/git/torvalds/linux-2.6.git).
> 
> Yesterday, after modify code in ffsport.c to sync up with the block layer APIs changes, I have make the kernel against linux-next tree and found no build error / warnings.
> 
> Then I generated the patch again Linus' kernel tree, tag 'v2.6.30-rc8' and sent the patch to you. This patch uses the new block layer APIs and is target for the linux-next tree.
> 
> I guess the below build errors are caused by compiling the patch code in Linus' kernel tree. As the block layer API's in Linus' kernel tree is still the old one, it'll report this kind of 'implicit declaration of function ...' error. I'm sorry for the mis-communication.
> 
> Now, I'm a bit confused with the process :-) Which git tree should I select to generate patch against and submit to? The linux-next tree or Linus' kerner tree?

One solution would be to generate the _main_ patch against Linus' tree
(for Greg to include in staging tree) and then generate _incremental_
patch with changes to account for block layer API update (for Stephen
to include in linux-next)..

Thanks.
Bart
