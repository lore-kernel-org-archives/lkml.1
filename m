Return-Path: <linux-kernel-owner+w=401wt.eu-S1760105AbYCFEt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760105AbYCFEt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 23:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757212AbYCFEtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 23:49:18 -0500
Received: from phunq.net ([64.81.85.152]:42298 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757148AbYCFEtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 23:49:17 -0500
From: Daniel Phillips <phillips@phunq.net>
To: david@lang.hm
Subject: Re: [RFC] An alternative interface to device mapper
Date: Wed, 5 Mar 2008 20:49:16 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <alpine.DEB.1.00.0803051830290.14137@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.00.0803051830290.14137@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803052049.16283.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 March 2008 18:30, you wrote:
> forgive the lack of threading, I missed this yesterday and just found this 
> via the LWN article.
> 
> I like the general approach that you are taking of simplifying the 
> interface, however in your interest of making it easy to write C code for 
> you are making the new interface difficult to script for. is it really 
> that painful to to make everything file based so that it can be scripted 
> as well?
> 
> frankly, most sysadmins do a lot of scripting and almost no C coding, so 
> while a nice C interface is useful for creating tools, a good scripting 
> interface is critical for good, flexible use by sysadmins.

Hi David,

Scripting is already taken care of by the ddsetup utility (a compatible
rewrite of dmsetup) which is just a shell to the ddlink interface.  You
would not want to put the "value add" of dmsetup into kernel.  All that
parsing and massaging belongs in user space.  If there are more scripting
features you need, they should be added to dmsetup/ddsetup, not to the
kernel.

Scripting device mapper has never actually posed a problem.  The real
problem is, there is no nice way to write a C program to do fancy
volume management, so we don't see the advanced features appearing on
Linux at anything like the rate they have appeared on Solaris.

Daniel
