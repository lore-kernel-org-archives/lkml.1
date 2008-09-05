Return-Path: <linux-kernel-owner+w=401wt.eu-S1751949AbYIEJY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbYIEJY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 05:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbYIEJYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 05:24:20 -0400
Received: from ns1.q-leap.de ([153.94.51.193]:48340 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbYIEJYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 05:24:20 -0400
From: Bernd Schubert <bs@q-leap.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: frame unwinder patches
Date: Fri, 5 Sep 2008 11:24:16 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <g9p3du$n95$1@ger.gmane.org> <87tzcvvi4p.fsf@basil.nowhere.org>
In-Reply-To: <87tzcvvi4p.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809051124.17194.bs@q-leap.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 September 2008 21:13:58 Andi Kleen wrote:
> Bernd Schubert <bs@q-leap.de> writes:
> > Hello,
> >
> > up to 2.6.22 the -mm series had these nice frame unwinder patches,
> > which gave beautiful stack traces. Unfortunately these frame unwinder
> > patches seem to have been dropped :(
> >
> > Anyone still maintaining updated patches?
>
> The SUSE kernel rpm should have an uptodate set
>
> (ftp.suse.com/pub/projects/kernel/HEAD )
>

Thanks Andi, found it! If someone else needs it, the correct path is 
ftp://ftp.suse.com/pub/projects/kernel/kotd/HEAD. 


> I agree that they were much better than the current unwinder,
> also they didn't require slowing down the kernel with
> frame pointers.

What it the reason this patch isn't mainline? It provides better traces, 
doesn't slow down the kernel (which is important in our HPC envirement), so 
what is the disadvantage?


Thanks again,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
