Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbYGAOFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbYGAOFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbYGAOEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:04:54 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:4656 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbYGAOEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:04:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Fp+JJzr5FMhnM6yS18qvjtWIt9nYrKe1hK6uGTaEuRDRyylhAhVvkm/Kohwpz0czIU
         vIPkyU3gSKrvoI765saOYASRLs1zW+GkyZ95TDCXPGpyVm0RdA6Z+I/Nu+IBRsrUcx82
         1q1E88lmsjOBugspzuRreS0F5C8Th5thHs+0Y=
Message-ID: <a4423d670807010704g6cc8513fxfdb258e0b1f873ac@mail.gmail.com>
Date: Tue, 1 Jul 2008 18:04:52 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Mel Gorman" <mel@csn.ul.ie>
Subject: Re: [Bug #10961] 2.6.26-rc: nfsd hangs for a few sec
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20080630210142.GB20245@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
	 <X8mbwW6K81I.A.PjD.169ZIB@albercik> <20080630210142.GB20245@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/1 Mel Gorman <mel@csn.ul.ie>:
> I still have no useful reaction to this. According to Christoph Hellwig,
> this lockup has been appearing since lockdep was introduced but for some
> reason is easier to trigger now. It bisected to the two-zonelist changes
> but it still looks like a red herring as I cannot see how reclaim has
> changed significantly as a result of that patch.

Do you wait reaction from me? Can I help?
As I mentioned, the lockup does not happen when lockdep is disabled.
