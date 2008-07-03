Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbYGCVlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbYGCVlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756996AbYGCVgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:36:54 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:42329 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756977AbYGCVgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:36:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NJuMfqgZwj9q8oACgHeIghSBK4E3wsQVnAwAdrirAeFRRLA0Ua6pn8l4fDYkkT+VnC
         XVjPbIUX7rZyI+XcAD3wVkm8/VENaHYCZAbAOfDmIFopUKKcP91KG5FSMeBuKNOuJGnM
         Dk5SZYWesPLLFADrgMF2Qfs2f6MLm1PMISt5o=
Message-ID: <a4423d670807031436k13959daan331c2b13e4b2c0f9@mail.gmail.com>
Date: Fri, 4 Jul 2008 01:36:44 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Mel Gorman" <mel@csn.ul.ie>
Subject: Re: [Bug #10961] 2.6.26-rc: nfsd hangs for a few sec
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20080703173903.GH18055@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
	 <X8mbwW6K81I.A.PjD.169ZIB@albercik> <20080630210142.GB20245@csn.ul.ie>
	 <a4423d670807010704g6cc8513fxfdb258e0b1f873ac@mail.gmail.com>
	 <20080703173903.GH18055@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/3 Mel Gorman <mel@csn.ul.ie>:
> This bug is likely fixed by commit 494de90098784b8e2797598cefdd34188884ec2e
> which will be visible publicly later when maintenance on master.kernel.org
> finishes. I included it below for convenience.
>
> The lockdep warning still exists but it is a false positive and should be
> relatively hard to trigger again. It would be nice to have confirmation
> of this.

Thanks! It helps.
No hangs and lockdep warnings now.

Rafael, please close it.
