Return-Path: <linux-kernel-owner+w=401wt.eu-S1767522AbXCITgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767522AbXCITgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 14:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767521AbXCITgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 14:36:22 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51772 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1767513AbXCITgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 14:36:21 -0500
Date: Fri, 9 Mar 2007 11:36:23 -0800
From: Paul Jackson <pj@sgi.com>
To: vatsa@in.ibm.com
Cc: ebiederm@xmission.com, menage@google.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, winget@google.com,
       containers@lists.osdl.org, akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka
 containers on top of nsproxy!
Message-Id: <20070309113623.51de3f5f.pj@sgi.com>
In-Reply-To: <20070309181908.GC21661@in.ibm.com>
References: <20070307205846.GB7010@sergelap.austin.ibm.com>
	<6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
	<m1odn4bs6n.fsf@ebiederm.dsl.xmission.com>
	<6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>
	<45EF5A62.8000103@vilain.net>
	<6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com>
	<45EF5E71.7090101@vilain.net>
	<6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com>
	<m1d53ka5b9.fsf@ebiederm.dsl.xmission.com>
	<20070309005357.GC4506@MAIL.13thfloor.at>
	<20070309181908.GC21661@in.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert wrote (and vatsa quoted):
> precisely, once you are inside a resource container, you
> must not have the ability to modify its limits, and to
> some degree, you should not know about the actual available
> resources, but only about the artificial limits

Not necessarily.  Depending on the resource we are managing, and on how
all encompassing one chooses to make the virtualization, this might be
an overly Draconian permission model.

Certainly in cpusets, any task can see the the whole system view, if
there are fairly typical permissions on some /dev/cpuset files.  A task
might even be able to change those limits for any task on the system,
if it has stronger priviledge.

Whether or not to really virtualize something, so that the contained
task can't tell it is in side a cacoon, is a somewhat separate question
from whether or not to limit a tasks use of a particular precious
resource.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
