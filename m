Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbYGSR0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbYGSR0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 13:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754360AbYGSR0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 13:26:16 -0400
Received: from outbound-mail-126.bluehost.com ([67.222.38.26]:49618 "HELO
	outbound-mail-126.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754200AbYGSR0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 13:26:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=UO153zczmfmkAohSjIJJTd4sSRfv/KEBwVtpM5EBJVVYBrlKCBd/vVY8ysb0ut04pVtWSvNd4NyVpwVuPTrXykYhhmw5y0NP3NZ7kuWR+Rk0C43t+Qy7R94i4VwAcP6V;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
Date: Sat, 19 Jul 2008 10:26:02 -0700
User-Agent: KMail/1.9.9
Cc: Jack Howarth <howarth@bromo.msbb.uc.edu>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>
References: <200807180941.09779.yhlu.kernel@gmail.com> <20080719051227.GA10044@bromo.msbb.uc.edu> <86802c440807182228u5259eba1x238ec3af5fc4324c@mail.gmail.com>
In-Reply-To: <86802c440807182228u5259eba1x238ec3af5fc4324c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807191026.03172.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 18, 2008 10:28 pm Yinghai Lu wrote:
> On Fri, Jul 18, 2008 at 10:12 PM, Jack Howarth
>
> <howarth@bromo.msbb.uc.edu> wrote:
> >   Would that imply that this might be more fallout of the BIOS bug in the
> > MacBook Pro where insufficient address space is reserved for the number
> > of buses claimed?
>
> that is good enough with 64 buses like laptop.
>
> > Is there some point in the PCIEASPM based code where you
> > could duplicate the same sort of fix? I would be happy to test any debug
> > patches that might help pinpoint where such a fix is needed.
>
> Jesse, who is maintainer for ASPM code?

I've been looking to Shaohua (cc'd) for ASPM stuff.

Jesse
