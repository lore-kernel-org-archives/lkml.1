Return-Path: <linux-kernel-owner+w=401wt.eu-S932887AbXCIEak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887AbXCIEak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 23:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932926AbXCIEak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 23:30:40 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34765 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932887AbXCIEaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 23:30:39 -0500
Date: Thu, 8 Mar 2007 20:30:41 -0800
From: Paul Jackson <pj@sgi.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: menage@google.com, sam@vilain.net, vatsa@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       xemul@sw.ru, dev@sw.ru, winget@google.com, containers@lists.osdl.org,
       serue@us.ibm.com, akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka
 containers on top of nsproxy!
Message-Id: <20070308203041.1fc5d340.pj@sgi.com>
In-Reply-To: <m1d53ka5b9.fsf@ebiederm.dsl.xmission.com>
References: <20070301133543.GK15509@in.ibm.com>
	<20070307174346.GA19521@sergelap.austin.ibm.com>
	<20070307180055.GC17151@in.ibm.com>
	<20070307205846.GB7010@sergelap.austin.ibm.com>
	<6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
	<m1odn4bs6n.fsf@ebiederm.dsl.xmission.com>
	<6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>
	<45EF5A62.8000103@vilain.net>
	<6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com>
	<45EF5E71.7090101@vilain.net>
	<6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com>
	<m1d53ka5b9.fsf@ebiederm.dsl.xmission.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The real trick is that I believe these groupings are designed to be something
> you can setup on login and then not be able to switch out of.  Which means
> we can't use sessions and process groups as the grouping entities as those 
> have different semantics.

Not always on login.  For big administered systems, we use batch schedulers
to manage the placement of multiple jobs, submitted to a run queue by users,
onto the available compute resources.

But I agree with your conclusion - the existing task grouping mechanisms,
while useful for some purposes, don't meet the need here.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
