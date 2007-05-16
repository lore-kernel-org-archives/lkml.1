Return-Path: <linux-kernel-owner+w=401wt.eu-S1758427AbXEPNtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427AbXEPNtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbXEPNto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:49:44 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:20222 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbXEPNto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:49:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oOpV/nkGVODQzns6ksDwsHzudd+edq6xfUuIXqWA9iBDJUMP0XJxG/v/ic0CbKasIpD4cNkcUVT3EaZcWS4j2Xvl+QdKpBnRXIa/5cu1Ee7u3eGwPJDNh8AZ+3mSBkq6LojqlsIP163lVLagON/mOFrcv1RCNNdOZlVQMefjzKE=
Message-ID: <e5ab0f710705160649s5a8a0ef8s8ba7f4be76bc873c@mail.gmail.com>
Date: Wed, 16 May 2007 15:49:42 +0200
From: "Francesco Pretto" <ceztko@gmail.com>
To: Stephen.Clark@seclark.us
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
Cc: "Rob Landley" <rob@landley.net>, "Dave Jones" <davej@redhat.com>,
       "Tejun Heo" <htejun@gmail.com>, "Phillip Susi" <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <464AFD61.10209@seclark.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no>
	 <46489D3B.8050805@gmail.com> <20070515210804.GG25902@redhat.com>
	 <200705160129.16048.rob@landley.net> <464AFD61.10209@seclark.us>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/16, Stephen Clark <Stephen.Clark@seclark.us>:
> >On Tuesday 15 May 2007 5:08 pm, Dave Jones wrote:
> >
> >I'm confused.  Could someone please explain?
> >
> I agree. This didn't happen when I was just using the ide driver, why
> can't libata work as well
> as the old ide driver.
>

Read my reply to that post. To summarize: libata, prior to 2.6.22rc1,
lacked the feature to spindown the hard disk. The last discussion was
about who's responsable to issue the STANDBYNOW command to the hard
disk. Response from the discussion is: the kernel. Trying to issue it
form userspace (iff your shutdown(8) implementation do so) will now
result in a big fat warning, until these compatibility measures will
be dropped from the kernel (soon or later).
