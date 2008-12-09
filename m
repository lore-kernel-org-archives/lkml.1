Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbYLIJwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbYLIJwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 04:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYLIJwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 04:52:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33302 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbYLIJwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 04:52:33 -0500
Message-ID: <493E3F8B.7070603@redhat.com>
Date: Tue, 09 Dec 2008 11:51:07 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: kvm@vger.kernel.org, Christian Borntraeger <borntraeger@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] module_refcounting and anonymous inodes
References: <200812021114.59050.borntraeger@de.ibm.com> <200812081251.14648.borntraeger@de.ibm.com> <493D0B9A.9000401@redhat.com> <200812091743.26586.sheng@linux.intel.com>
In-Reply-To: <200812091743.26586.sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sheng Yang wrote:
> Should we push the first patch to 2.6.28? 

It's not a recent regression, so no.

> I got some trouble with the separate 
> 2nd patch, for I am using Linus' tree and make KVM as modules, so the 
> reference count reduced to negative now... (Oh Avi, I know you suggest to use 
> in kernel rather than modules, but module is indeed convenient. :) )
>   

Right, that would affect everyone.  What we need is to hack the second 
patch for external modules on <2.6.29.

-- 
error compiling committee.c: too many arguments to function

