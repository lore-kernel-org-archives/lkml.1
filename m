Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbXCMP5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbXCMP5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbXCMP5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:57:08 -0400
Received: from MAIL.13thfloor.at ([213.145.232.33]:39751 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbXCMP5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:57:07 -0400
Date: Tue, 13 Mar 2007 16:57:06 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>, ebiederm@xmission.com, matthltc@us.ibm.com,
       ckrm-tech@lists.sourceforge.net, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       winget@google.com, xemul@sw.ru
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070313155706.GO8755@MAIL.13thfloor.at>
Mail-Followup-To: Paul Menage <menage@google.com>,
	Paul Jackson <pj@sgi.com>, ebiederm@xmission.com,
	matthltc@us.ibm.com, ckrm-tech@lists.sourceforge.net,
	containers@lists.osdl.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, winget@google.com, xemul@sw.ru
References: <6599ad830703071857yf711921ja3440c4276bbe58e@mail.gmail.com> <45EF83CB.9080903@vilain.net> <1173334209.13172.61.camel@localhost.localdomain> <m11wk08c9h.fsf@ebiederm.dsl.xmission.com> <20070309010628.GE4506@MAIL.13thfloor.at> <45F27503.1020108@vilain.net> <20070311141555.9951b7ba.pj@sgi.com> <6599ad830703120300x63ca5732wfe865f76cb5125a9@mail.gmail.com> <20070312232143.GC6832@MAIL.13thfloor.at> <6599ad830703121925p7049db95nccedfc32609e6ae6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830703121925p7049db95nccedfc32609e6ae6@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 07:25:48PM -0700, Paul Menage wrote:
> On 3/12/07, Herbert Poetzl <herbert@13thfloor.at> wrote:
> >
> > why? you simply enter that specific space and
> > use the existing mechanisms (netlink, proc, whatever)
> > to retrieve the information with _existing_ tools,
> 
> That's assuming that you're using network namespace virtualization,

or isolation :)

> with each group of tasks in a separate namespace. 

correct ...

> What if you don't want the virtualization overhead, just the
> accounting?

there should be no 'virtualization' overhead, and what
do you want to account for, if not by a group of tasks?

maybe I'm missing the grouping condition here, but I
assume you assign tasks to the accounting containers

note: network isolation is not supposed to add overhead
compared to the host system (at least not measureable
overhead)

best,
Herbert

> Paul
> _______________________________________________
> Containers mailing list
> Containers@lists.osdl.org
> https://lists.osdl.org/mailman/listinfo/containers
