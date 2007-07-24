Return-Path: <linux-kernel-owner+w=401wt.eu-S1760100AbXGXNTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100AbXGXNTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 09:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbXGXNS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 09:18:57 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:48690 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbXGXNS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 09:18:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ik5uKUbfBG4K1fuBvk9X8mP23k9zUIQDi4UgOZvqhDaiV2k4UyLOdmu4L7yQU7vP2Jl82YfWpDkv4CDiC3PQmPaWz1FmyP/7I5z72gSV10tfWmTkCD1JGt7j7JSacslwyOJnOyA4E+nS0Ck9teVhHjhfidD5f4MaWqGeU+i5OsU=
Message-ID: <288dbef70707240618l71bd8678n28a39e663dab3c1c@mail.gmail.com>
Date: Tue, 24 Jul 2007 21:18:55 +0800
From: "Shaohua Li" <shaoh.li@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: [kvm-devel] [RFC 4/8]KVM: move gfn_to_page out of kmap/unmap pars
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <46A5C884.8060200@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1185173499.2645.68.camel@sli10-conroe.sh.intel.com>
	 <46A5C884.8060200@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/24, Avi Kivity <avi@qumranet.com>:
> Shaohua Li wrote:
> > gfn_to_page might sleep with swap support. Move it out of the kmap calls.
> >
> >
>
> I'd like to apply this to the kvm.git master branch so we don't have to
> maintain it.  Was this tested on a highmem machine?  If not, I can do it.
My test system has 1G memory, so it should work. I only tested 32bit
system, better check a x64 build.

Thanks,
Shaohua
