Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYA0I5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYA0I5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 03:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbYA0I5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 03:57:11 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:44374
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbYA0I5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 03:57:10 -0500
Message-ID: <479C4763.1080104@qumranet.com>
Date: Sun, 27 Jan 2008 10:57:07 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH][RFC] SVM: Add Support for Nested Paging in
 AMD Fam16 CPUs
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Hi,                                                                                                                              
>
> here is the first release of patches for KVM to support the Nested Paging (NPT)
> feature of AMD QuadCore CPUs for comments and public testing. This feature
> improves the guest performance significantly. I measured an improvement of
> around 17% using kernbench in my first tests.
>
> This patch series is basically tested with Linux guests (32 bit legacy
> paging, 32 bit PAE paging and 64 bit Long Mode). Also tested with Windows Vista
> 32 bit and 64 bit. All these guests ran successfully with these patches. The
> patch series only enables NPT for 64 bit Linux hosts at the moment.
>   


Very nice patchset; small, simple, and clean.  Apart from the comments I 
already posted, I'd like to avoid the term 'hap': I find it 
non-descriptive, and it reminds me of another hypervisor.  I suggest 
'tlp' for two-level paging.

Since it re-uses non-npt real-mode paging, live migration and swapping 
will likely work without further changes.

-- 
error compiling committee.c: too many arguments to function

