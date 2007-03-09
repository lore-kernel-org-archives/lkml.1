Return-Path: <linux-kernel-owner+w=401wt.eu-S2992818AbXCIA5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992818AbXCIA5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:57:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992823AbXCIA5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:57:04 -0500
Received: from MAIL.13thfloor.at ([213.145.232.33]:40923 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992818AbXCIA5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:57:03 -0500
Date: Fri, 9 Mar 2007 01:56:39 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       xemul@sw.ru, pj@sgi.com, winget@google.com, containers@lists.osdl.org,
       akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070309005639.GD4506@MAIL.13thfloor.at>
Mail-Followup-To: Paul Menage <menage@google.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	xemul@sw.ru, pj@sgi.com, winget@google.com,
	containers@lists.osdl.org, akpm@linux-foundation.org
References: <20070307205846.GB7010@sergelap.austin.ibm.com> <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com> <m1odn4bs6n.fsf@ebiederm.dsl.xmission.com> <6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com> <45EF5A62.8000103@vilain.net> <6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com> <45EF5E71.7090101@vilain.net> <6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com> <m1d53ka5b9.fsf@ebiederm.dsl.xmission.com> <6599ad830703071735m222e26b7v47a54ca0aaffd902@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830703071735m222e26b7v47a54ca0aaffd902@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 05:35:58PM -0800, Paul Menage wrote:
> On 3/7/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Pretty much. For most of the other cases I think we are safe
>> referring to them as resource controls or resource limits. I know
>> that roughly covers what cpusets and beancounters and ckrm currently
>> do.
> 
> Plus resource monitoring (which may often be a subset of resource
> control/limits).

we (Linux-VServer) call that resource accounting, and
it is the first step to resource limits ...

> > The real trick is that I believe these groupings are designed to be
> > something you can setup on login and then not be able to switch out
> > of.
> 
> That's going to to be the case for most resource controllers - is that
> the case for namespaces? (e.g. can any task unshare say its mount
> namespace?)

ATM, yes, and there is no real harm in doing so
this would be a problem for resource containers,
unless they are strict hierarchical, i.e. only
allow to further restrict the existing resources
(which might cause some trouble if existing limits
have to be changed at some point)

best,
Herbert

> Paul
> _______________________________________________
> Containers mailing list
> Containers@lists.osdl.org
> https://lists.osdl.org/mailman/listinfo/containers
