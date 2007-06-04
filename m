Return-Path: <linux-kernel-owner+w=401wt.eu-S1752523AbXFDVLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbXFDVLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbXFDVLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:11:08 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41592 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194AbXFDVLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:11:05 -0400
Date: Mon, 4 Jun 2007 16:11:03 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, akpm@linux-foundation.org, dev@sw.ru,
       xemul@sw.ru, vatsa@in.ibm.com, ebiederm@xmission.com,
       haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com, balbir@in.ibm.com,
       pj@sgi.com, cpw@sgi.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       mbligh@google.com, rohitseth@google.com, devel@openvz.org
Subject: Re: [PATCH 00/10] Containers(V10): Generic Process Containers
Message-ID: <20070604211103.GA15923@sergelap.austin.ibm.com>
References: <20070529130104.461765000@menage.corp.google.com> <20070604191412.GA901@sergelap.austin.ibm.com> <6599ad830706041332o718acb60ve0b5e38c2ca82c62@mail.gmail.com> <20070604205106.GA31530@sergelap.austin.ibm.com> <6599ad830706041356r5a031dd5w2eeb3ff4c7c64b72@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830706041356r5a031dd5w2eeb3ff4c7c64b72@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> On 6/4/07, Serge E. Hallyn <serue@us.ibm.com> wrote:
> >root@linuz11 root]# rm -rf /containers/1
> 
> Just use "rmdir /containers/1" here.

Hmm.  Ok, that works...  Odd, I thought rm -rf used to work in the past,
but i'm likely wrong.

thanks,
-serge

> >Ah, I see the second time I typed 'ls /containers/1/tasks' instead of
> >cat.  When I then used cat, the file was empty, and I got an oops just
> >like Pavel reported.  I bet if I solve the problem he reported, then I
> >solve my problem  :)
> >
> 
> As far as I could see, Pavel's problem wasn't actually an Oops, it was
> a WARN_ON() when allocating a zero length chunk of memory. There's
> ongoing discussion as to whether this counts as a problem with the
> allocators or the kmalloc() code, since it used to be OK to allocate a
> zero-length chunk.
> 
> Paul
