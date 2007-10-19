Return-Path: <linux-kernel-owner+w=401wt.eu-S1764825AbXJSPNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764825AbXJSPNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 11:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbXJSPNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 11:13:39 -0400
Received: from il.qumranet.com ([82.166.9.18]:34773 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775AbXJSPNj (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 11:13:39 -0400
Message-ID: <4718C9A1.3010703@qumranet.com>
Date: Fri, 19 Oct 2007 17:13:37 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: carsteno@de.ibm.com
CC: "kvm-devel@lists.sourceforge.net" <kvm-devel@lists.sourceforge.net>,
       Linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] severe bug in 2.6.23+ kvm.git
References: <47189371.7080104@de.ibm.com>
In-Reply-To: <47189371.7080104@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Fri, 19 Oct 2007 17:13:37 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carsten Otte wrote:
> Hi list,
>
> we've experienced a severe bug in current kvm.git, that may have been 
> introduced to the git tree quite recently around last weekend. 2.6.23 
> is broken, 2.6.23-rc8 works for us. The symptom is, that our operon 
> kvm test machine shredders its hard disk content to a state that is 
> not correctably by the file system checker. We use raid1 md mirrored 
> ext3 file systems on 4 sata hard disks on it, and we've verified 
> correct operation of the hardware via badblocks and memtest86.
> The problem occurs even without kvm modules loaded, so the cause seems 
> to be something that Avi pulled elsewhere. Did anyone else experience 
> similar problems with the 2.6.23 based kvm tree? Does anyone have an 
> idea about a possible cause, which would help us debugging it?
>
>   

kvm.git is actually 2.6.24-rc, pulled from -linus at a random point in
time, so it's not at all surprising if something is broken.

One option is for you to pull -linus to get the latest and hopefully
greatest and see if the bug is fixed.

Another is to use the external module capability to build kvm.git
against 2.6.23.1.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

