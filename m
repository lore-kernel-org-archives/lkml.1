Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbZJ2ND4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbZJ2ND4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 09:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbZJ2ND4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 09:03:56 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:52669 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbZJ2NDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 09:03:55 -0400
Date: Thu, 29 Oct 2009 09:03:09 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Avi Kivity <avi@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Glauber Costa <glommer@redhat.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall
 implementation
Message-ID: <20091029130309.GA2750@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Avi Kivity <avi@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
	Glauber Costa <glommer@redhat.com>,
	Dan Magenheimer <dan.magenheimer@oracle.com>,
	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
	kurt.hackel@oracle.com, the arch/x86 maintainers <x86@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Glauber de Oliveira Costa <gcosta@redhat.com>,
	Xen-devel <xen-devel@lists.xensource.com>,
	Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
	Ingo Molnar <mingo@redhat.com>
References: <4f079cd6-0872-4cb5-832b-ee6a46841192@default>
 <4AE739DA.20601@goop.org>
 <4AE7DC04.7080706@redhat.com>
 <20091028092900.GG3627@mothafucka.localdomain>
 <4AE81011.4040904@redhat.com>
 <4AE883B9.4050409@goop.org>
 <4AE986FE.3040104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE986FE.3040104@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4AE99292.00A2:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 02:13:50PM +0200, Avi Kivity wrote:
> On 10/28/2009 07:47 PM, Jeremy Fitzhardinge wrote:
> >>Much better to have an API for this.  Life is hacky enough already.
> >My point is that if an app cares about property X then it should just
> >measure property X.  The fact that gettimeofday is a vsyscall is just an
> >implementation detail that apps don't really care about.  What they care
> >about is whether gettimeofday is fast or not.
> 
> But we can not make a reliable measurement.

I can't imagine how we'd decide what fast is?  Please don't make the
applications guess.

-chris
