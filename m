Return-Path: <linux-kernel-owner+w=401wt.eu-S932140AbXDRE4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbXDRE4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 00:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbXDRE4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 00:56:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55172 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753774AbXDRE4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 00:56:04 -0400
Date: Tue, 17 Apr 2007 21:56:02 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Yasunori Goto <y-goto@jp.fujitsu.com>
cc: Larry Woodman <lwoodman@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysctl_panic_on_oom broken
In-Reply-To: <20070418104631.EE4A.Y-GOTO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0704172154150.2877@schroedinger.engr.sgi.com>
References: <462515CC.1080107@redhat.com> <Pine.LNX.4.64.0704171438390.8082@schroedinger.engr.sgi.com>
 <20070418104631.EE4A.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007, Yasunori Goto wrote:

> If panic_on_oom is 1, only panic if mempolicy/cpuset is not used.
> And if panic_on_oom is 2, panic on all case.
> This might be desirable.

Sounds good. Add some documentation mentioned that this may panic your 
system if there is still plenty of memory available.

