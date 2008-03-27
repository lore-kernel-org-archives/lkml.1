Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbYC0BZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbYC0BZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 21:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbYC0BZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 21:25:40 -0400
Received: from relay2.sgi.com ([192.48.171.30]:34936 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754261AbYC0BZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 21:25:39 -0400
Date: Wed, 26 Mar 2008 18:23:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: Trying to make use of hotplug memory for xen balloon driver
In-Reply-To: <1206576544.7883.21.camel@nimitz.home.sr71.net>
Message-ID: <Pine.LNX.4.64.0803261821580.1115@schroedinger.engr.sgi.com>
References: <47EAD83A.2000000@goop.org> <1206576544.7883.21.camel@nimitz.home.sr71.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Dave Hansen wrote:

> You might also note that most of the ppc64 memory hotplug is driven by
> userspace.  The hypervisor actually contacts a daemon on the guest to
> tell it where its new memory is.  That daemon does the addition
> through /sys/devices/system/memory/probe.  

Would it be possible to have the balloon driver use the memory hotplug 
interface instead? That would generalize the memory hotplug logic and you 
will likely find that lots of issues have already been addressed in that 
code.



