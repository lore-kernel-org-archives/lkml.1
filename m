Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbYIZIur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbYIZIur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 04:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbYIZIuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 04:50:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:9392 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbYIZIui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 04:50:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VgjUfERiHerVp/0wHboGNyKV1+RfNp3pXIGRVNkx7c7ELA5/126lMhKqUh9Xd8YP3K
         HNC7trpUoKr+zwkdhsQvrDQ6VTZ3hh197UeL233uy/G+H2EklZKDq9KhYFhXdkGa31x0
         1DOrwVSOVvMQWHOFdG01cQANxUafhLnhqAqUo=
Date: Fri, 26 Sep 2008 12:50:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tej <bewith.tej@gmail.com>, Jason Wessel <jason.wessel@windriver.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel PANIC with 2.6.27-rc6
Message-ID: <20080926085033.GA16849@localhost>
References: <f1c9d250809110841s5c3d08b9ha93f0ef1da58642a@mail.gmail.com> <48C94F65.3050405@windriver.com> <f1c9d250809250735i4b98201ft753d6ec2959097e6@mail.gmail.com> <20080925145635.GA7277@localhost> <20080925154724.GB7277@localhost> <f1c9d250809251134j6fac8bfu43f08cbf2b330f0a@mail.gmail.com> <20080925193956.GF7259@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925193956.GF7259@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Thu, Sep 25, 2008 at 11:39:56PM +0400]
| [Tej - Fri, Sep 26, 2008 at 12:04:30AM +0530]
| ...
| 
| Btw Tej, could you please apply this patch
| and check if it help.
| 
| 	http://lkml.org/lkml/2008/9/22/250
| 
| Aristeu Rozanski fixed one race window which take
| place on unpredicted nmi's.
| 
| 		- Cyrill -

Btw Tej, could you post boot log if kernel were started as

	root=/dev/sda1 ro debug apic=debug kgdbts=V2 splash console=tty0 console=ttyS0,

Ie your original option "quiet" is to be replace with "debug apic=debug kgdbts=V2".
Thanks!

		- Cyrill -
