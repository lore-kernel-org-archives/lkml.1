Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbZJGWkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbZJGWkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755621AbZJGWkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:40:11 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:36428 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604AbZJGWkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:40:09 -0400
MIME-Version: 1.0
Message-ID: <a5848618-ef48-43c8-a8c0-f3b4604cfede@default>
Date: Wed, 7 Oct 2009 15:36:58 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Avi Kivity <avi@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       chris.mason@oracle.com
Subject: RE: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall
 implementation
In-Reply-To: <4ACD0333.9060603@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.4  (308245) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4ACD1851.00D0:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Then they will get incorrect timing once they are live migrated.

I've posted a proposed (OS-independent) solution for that and
am (slowly) in the process of implementing it.

> -----Original Message-----
> From: Avi Kivity [mailto:avi@redhat.com]
> Sent: Wednesday, October 07, 2009 3:08 PM
> To: Dan Magenheimer
> Cc: Jeremy Fitzhardinge; Jeremy Fitzhardinge; Xen-devel; Kurt Hackel;
> the arch/x86 maintainers; Linux Kernel Mailing List; Glauber 
> de Oliveira
> Costa; Keir Fraser; Zach Brown; Chris Mason
> Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall
> implementation
> 
> 
> On 10/07/2009 10:48 PM, Dan Magenheimer wrote:
> >> We can support them by falling back to the kernel.  I'm a 
> bit worried
> >> about the kernel playing with the hypervisor's version field.  It's
> >> better to introduce yet a new version for the kernel, and 
> check both.
> >>      
> > On Nehalem, apps that need timestamp information at a high
> > frequency will likely use rdtsc/rdtscp directly.
> >
> >    
> 
> Then they will get incorrect timing once they are live migrated.
> 
> -- 
> I have a truly marvellous patch that fixes the bug which this
> signature is too narrow to contain.
> 
> 
>
