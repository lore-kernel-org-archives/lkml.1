Return-Path: <linux-kernel-owner+w=401wt.eu-S1767450AbXCISMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767450AbXCISMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 13:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767453AbXCISMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 13:12:12 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:50871 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767450AbXCISMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 13:12:10 -0500
Date: Fri, 9 Mar 2007 23:49:08 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Paul Menage <menage@google.com>, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, pj@sgi.com,
       winget@google.com, containers@lists.osdl.org, akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070309181908.GC21661@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070307205846.GB7010@sergelap.austin.ibm.com> <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com> <m1odn4bs6n.fsf@ebiederm.dsl.xmission.com> <6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com> <45EF5A62.8000103@vilain.net> <6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com> <45EF5E71.7090101@vilain.net> <6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com> <m1d53ka5b9.fsf@ebiederm.dsl.xmission.com> <20070309005357.GC4506@MAIL.13thfloor.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309005357.GC4506@MAIL.13thfloor.at>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 01:53:57AM +0100, Herbert Poetzl wrote:
> > The real trick is that I believe these groupings are designed to
> > be something you can setup on login and then not be able to switch
> > out of. Which means we can't use sessions and process groups as the
> > grouping entities as those have different semantics.
> 
> precisely, once you are inside a resource container, you
> must not have the ability to modify its limits, and to
> some degree, you should not know about the actual available
> resources, but only about the artificial limits

>From non-container workload management perspective, we do desire dynamic
manipulation of limits associated with a group and also the ability to move 
tasks across resource-classes/groups.

-- 
Regards,
vatsa
