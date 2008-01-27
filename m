Return-Path: <linux-kernel-owner+w=401wt.eu-S1760466AbYA0KAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760466AbYA0KAF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 05:00:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757882AbYA0Jvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:51:38 -0500
Received: from 8bytes.org ([88.198.83.132]:33410 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758482AbYA0Jvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:51:36 -0500
Date: Sun, 27 Jan 2008 10:51:35 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH][RFC] SVM: Add Support for Nested Paging in AMD Fam16 CPUs
Message-ID: <20080127095135.GB32677@8bytes.org>
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com> <479C4763.1080104@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479C4763.1080104@qumranet.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2008 at 10:57:07AM +0200, Avi Kivity wrote:
> Joerg Roedel wrote:
> > Hi,                                                                                                                              
> >
> > here is the first release of patches for KVM to support the Nested Paging (NPT)
> > feature of AMD QuadCore CPUs for comments and public testing. This feature
> > improves the guest performance significantly. I measured an improvement of
> > around 17% using kernbench in my first tests.
> >
> > This patch series is basically tested with Linux guests (32 bit legacy
> > paging, 32 bit PAE paging and 64 bit Long Mode). Also tested with Windows Vista
> > 32 bit and 64 bit. All these guests ran successfully with these patches. The
> > patch series only enables NPT for 64 bit Linux hosts at the moment.
> >   
> 
> 
> Very nice patchset; small, simple, and clean.  Apart from the comments I 
> already posted, I'd like to avoid the term 'hap': I find it 
> non-descriptive, and it reminds me of another hypervisor.  I suggest 
> 'tlp' for two-level paging.
> 
> Since it re-uses non-npt real-mode paging, live migration and swapping 
> will likely work without further changes.

Yes, I think so too. Thank you for your comments. I will work them into
the patchset and run some larger tests on it next week (test with many
kinds of guests and some stress testing) to be sure that there are no
regressions. I would like to enable NPT per default when the patchset
is merged. I will post a new version of the patchset maybe on Thursday
or Friday.

Joerg
