Return-Path: <linux-kernel-owner+w=401wt.eu-S1757934AbZBEQPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934AbZBEQPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbZBEQPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:15:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:48178 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbZBEQPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:15:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Bi4CAPmV2ESII6bC/01IBfRKPmqetdwSfds3ptmtxVLCTV/XUr4rev3xagwH00vtsT
         HwKGzXeXX5TgZCb1cFlV13wXQq7iqnkEQM657PjlZwh+iFtFZNY18iKqVjDCgRpjhBp3
         BUC6hY2E4nz5Z8dzzPVmvxjdzCJDpWU56tXNY=
MIME-Version: 1.0
In-Reply-To: <1233310639-27916-1-git-send-email-andi@firstfloor.org>
References: <1233310639-27916-1-git-send-email-andi@firstfloor.org>
Date: Thu, 5 Feb 2009 08:15:34 -0800
Message-ID: <eada2a070902050815h6ba682e2u158c4bb7c32f89ef@mail.gmail.com>
Subject: Re: Genapic cleanup & NUMAQ/es7000 removal
From: Tim Pepper <tpepper@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30, 2009 at 2:17 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Just to demonstrate the clean up possibilities by removing es7000
> and numaq here's a sample patch series. It doesn't actually remove
> the es7000/numaq code, but just marks them broken and then
> removes all the hooks only used by them. I'm not actually sure
> I caught all the now unused hooks, there are probably now more.
> Also I think there's still some other NUMAQ only code in smpboot.c
> that could be exercised.
>
> This removes 6 hooks and 2 fields out of struct genapic (out of 26
> hooks, a reduction of ~23%!)
>
> The first three patches are independent cleanups that should
> be applied anyways.
>
> This gives a nice generic cleanup:


These look good to me for inclusion along with the big "x86: unify
genapic code, unify subarchitectures, remove old subarchitecture code"
series, or as Andi's indicated the initial cleanups themselves if the
other big set doesn't make the 2.6.30 for some reason.  For this
series:

Acked-by: Tim Pepper <lnxninja@linux.vnet.ibm.com>
