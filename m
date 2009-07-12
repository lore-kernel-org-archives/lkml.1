Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbZGLUlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbZGLUlG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 16:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbZGLUky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 16:40:54 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:56974 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbZGLUkx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 16:40:53 -0400
MIME-Version: 1.0
Message-ID: <e60ab548-f0be-4a75-a10b-1f2eb89247a7@default>
Date: Sun, 12 Jul 2009 13:39:07 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Avi Kivity <avi@redhat.com>
Cc: npiggin@suse.de, akpm@osdl.org, xen-devel@lists.xensource.com,
       tmem-devel@oss.oracle.com, kurt.hackel@oracle.com,
       Rusty Russell <rusty@rustcorp.com.au>, jeremy@goop.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       sunil.mushran@oracle.com, chris.mason@oracle.com,
       Anthony Liguori <anthony@codemonkey.ws>,
       Schwidefsky <schwidefsky@de.ibm.com>, dave.mccracken@oracle.com,
       Marcelo Tosatti <mtosatti@redhat.com>, alan@lxorguk.ukuu.org.uk,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: RE: [Xen-devel] Re: [RFC PATCH 0/4] (Take 2): transcendent memory
 ("tmem") for Linux
In-Reply-To: <4A5A1A51.2080301@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.2  (306040) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4A5A4A23.01EE:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> CMM2 and tmem are not any different in this regard; both require OS 
> modification, and both make information available to the 
> hypervisor.  In 
> fact CMM2 is much more intrusive (but on the other hand provides much 
> more information).
>
> > For those that believe it will be pervasive in the
> > future, finding the right balance is a critical step
> > in operating system evolution.
> 
> You're arguing for CMM2 here IMO.

I'm arguing that both are a good thing and a step in
the right direction.  In some ways, tmem is a bigger
step and in some ways CMM2 is a bigger step.

> My take on this is that precache (predecache?) / preswap can be 
> implemented even without tmem by using write-through backing for the 
> virtual disk.  For swap this is actually slight;y more efficient than 
> tmem preswap, for preuncache slightly less efficient (since 
> there will 
> be some double caching).  So I'm more interested in other use 
> cases of tmem/CMM2.
> 
> Right, the transient uses of tmem when applied to disk objects 
> (swap/pagecache) are very similar to disk caches.  Which is 
> why you can 
> get a very similar effect when caching your virtual disks; 
> this can be 
> done without any guest modification.

Write-through backing and virtual disk cacheing offer a
similar effect, but it is far from the same.
