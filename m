Return-Path: <linux-kernel-owner+w=401wt.eu-S1763488AbYARQ43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763488AbYARQ43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763258AbYARQ4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:56:13 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:63791 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763248AbYARQ4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:56:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dnpJuw/NrsXdHY1qJVWXKBjj7XqVEOec28BZ5c4oRmnnG30PsUFuPNp4NStKLH6ssiLBtD49/3kgCLEmMVmTOkm3bvvAaVHGx833sJ0cMCeT9/D7ZgAzI8bX4/LKb2AMlCQy5vtGHSfYdZmafWsfDN4eCGB8DDHFMi9GmxQWEtE=
Message-ID: <519a8b110801180856o7757889as47106fd3eabcc0de@mail.gmail.com>
Date: Fri, 18 Jan 2008 17:56:09 +0100
From: xming <xmingske@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: Cannot boot xen DomU > 2.6.23.1
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>
In-Reply-To: <4790D187.8050000@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <519a8b110801170813h96b8f2by795e6d8b72a00ba4@mail.gmail.com>
	 <478F8D22.60004@goop.org>
	 <519a8b110801171113y20a3bedfg446e29a30712a26d@mail.gmail.com>
	 <4790561E.9040508@goop.org>
	 <519a8b110801180438l389ec1d6t7b888b8c78d59dd8@mail.gmail.com>
	 <4790D187.8050000@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 18, 2008 5:19 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> > First of all this patch solves the lock-ups, it works as advertised :)
>
> OK, good.  I guess events are getting lost somewhere with vcpu_info
> placement.


> Would it be possible to map the eip and some top parts of the stack back
> to kernel symbols?  Seems to be the same place in both traces, which is
> interesting.

Can you tell me how, or show me some pointers?


> > Scenario 2 (have_vcpu_info_placement = 0)
> > --------------------------------------------------------------
> >
> > test1: no crash
> > test2: no crash, but occationally I still get funny output like this
> >
> > 00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
> > 00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
> > 00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
> > 00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
> > 0000AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
> > 00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
> > 00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
> > 000AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
> > 000AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
> > 00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
> >
>
> Hm, I guess some of the output is getting dropped.  Does this happen
> with 2.6.18-xen?

yes it does

00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
0000AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ

# uname -a
Linux builder 2.6.18-xen-r8 #3 SMP Thu Dec 20 15:07:20 CET 2007 i686
AMD Athlon(tm) X2 Dual Core Processor BE-2300 AuthenticAMD GNU/Linux

cheers

xming
