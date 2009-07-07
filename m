Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbZGGUJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbZGGUJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 16:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757010AbZGGUJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 16:09:15 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:35012 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928AbZGGUJO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 16:09:14 -0400
MIME-Version: 1.0
Message-ID: <8422d908-c9e9-4497-82b7-a8532a66fd22@default>
Date: Tue, 7 Jul 2009 13:07:44 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, akpm@osdl.org,
       jeremy@goop.org, xen-devel@lists.xensource.com,
       tmem-devel@oss.oracle.com, alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org,
       kurt.hackel@oracle.com, Rusty Russell <rusty@rustcorp.com.au>,
       dave.mccracken@oracle.com, Marcelo Tosatti <mtosatti@redhat.com>,
       sunil.mushran@oracle.com, Avi Kivity <avi@redhat.com>,
       Schwidefsky <schwidefsky@de.ibm.com>, chris.mason@oracle.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: RE: [RFC PATCH 1/4] (Take 2): tmem: Core API between kernel and tmem
In-Reply-To: <4A538A34.7060101@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.2  (306040) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.4A53AB3D.0266:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Rik van Riel [mailto:riel@redhat.com]
> Subject: Re: [RFC PATCH 1/4] (Take 2): tmem: Core API between 
> 
> Dan Magenheimer wrote:
> > Tmem [PATCH 1/4] (Take 2): Core API between kernel and tmem
> 
> I like the cleanup of your patch series.

Thanks much, but credit goes to Jeremy for suggesting this
very clean tmem_ops interface.
 
> However, what remains is a fair bit of code.

Yes, though much of the LOC is for clean layering and
readability.  (Nearly half of the patch is now comments.)

> It would be good to have performance numbers before
> deciding whether or not to merge all this code.

On one benchmark that I will be presenting at Linux Symposium
(8 dual-VCPU guests with 384MB of initial memory and doing
self-ballooning to constrain memory, each guest compiling
Linux continually; quad-core-dual-thread Nehalem processor
with 4GB physical RAM) I am seeing savings of ~300 IO/sec
at an approximate cost of 0.1%-0.2% of one CPU.  But
I admit much more benchmarking needs to be done.

Thanks,
Dan

