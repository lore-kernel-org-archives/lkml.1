Return-Path: <linux-kernel-owner+w=401wt.eu-S1422741AbXBHF0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422741AbXBHF0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 00:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422749AbXBHF0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 00:26:40 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:43507 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422741AbXBHF0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 00:26:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EC70piubnZNDCBB63NpVM0XyPuYW+58TeXvORBUmU7+huJOWE2cbwqI7CHks65hxpD76zBjka1cuy7x17BbXiWDgGjn90UXrKBsSdmo1R+EQ9OYRR6LLEdbg4TWLF0V1CE+8NLarCHB1scRTe7cqC3+OChsPxUAvqNOzXdqL8YE=
Message-ID: <1a297b360702072126n14ef1991n7c7419f4a6ea19aa@mail.gmail.com>
Date: Thu, 8 Feb 2007 09:26:37 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Grant Grundler" <grundler@parisc-linux.org>
Subject: Re: 2.6.20 PCI Cannot allocate resource region 2
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, greg@kroah.com
In-Reply-To: <20070207065803.GA15076@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1a297b360702041709l3b0309c7y8fcd33df1d487889@mail.gmail.com>
	 <20070206045528.GA4228@colo.lackof.org>
	 <20070206050331.GB4228@colo.lackof.org>
	 <20070205213339.80239a22.akpm@linux-foundation.org>
	 <20070206084638.GB20752@colo.lackof.org>
	 <1a297b360702060313n34a8f941oebf9f373630b070f@mail.gmail.com>
	 <1a297b360702060352y3faa0f46i7c4a01499fae2eff@mail.gmail.com>
	 <20070207065803.GA15076@colo.lackof.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/07, Grant Grundler <grundler@parisc-linux.org> wrote:
> On Tue, Feb 06, 2007 at 03:52:47PM +0400, Manu Abraham wrote:
> > >attaching a dump of the regs (on 2.6.17.7) as well as the diff
> >
> > The device now works, used the demodulator driver alongwith the bridge
> > driver.
>
> Ok - thanks for the dmesg output and log. I suspect you've already
> tried cycling power on the machine (If not, please do).

I did power cycling on the machine .. did try pulling out the power
cord out for a while as well, to check whether it is some "fix that
just evaporated"


> I have no idea what M$ XP was doing that might "fix" the problem.
>
> I was just suspicious of our byte accesses to the same dword.
> To answer you previous question, it's possible that M$ only
> uses dword accesses. I don't know.
>


someone who has access to NT HAL inside ideas (maybe a too far deam) ,
could probably explain ?


> > inlined the log
>
> excellent - sounds like you are making forward progress even
> if we can not reproduce the problem...worst case other users
> (or customers) have a "work around" :^/

Sounds like a horrible workaround . :-)

I am thinking more in the direction of something wrong in the BIOS, as
that is the only dark area, where i can't see/understand anything.


regards,
manu
