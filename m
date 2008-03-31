Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbYCaCUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbYCaCUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 22:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbYCaCUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 22:20:13 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:13461 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbYCaCUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 22:20:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nmZy2o2LjZkddFRw471CXUxYOnPjdu7hlWSWwtDR9mt0mY4MoCNFtIST+n8YzN4+DFaid46Z0xaVCu+796Ix/GwtlIXuOLHLAsiujrXCGMXARJwpsWiFQyyyUgrMUuBN3/vts1tcmNS1SSBTxj3qMTzwbJfPiZsxoZhEcHbr/II=
Message-ID: <86802c440803301920o47335876yac12a5a09d1a8cc9@mail.gmail.com>
Date: Sun, 30 Mar 2008 19:20:11 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Steiner" <steiner@sgi.com>
Subject: Re: [RFC 8/8] x86_64: Support for new UV apic
Cc: "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080331021821.GC20619@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080324182122.GA28327@sgi.com> <87abknhzhd.fsf@basil.nowhere.org>
	 <20080325175657.GA6262@sgi.com> <20080326073823.GD3442@elte.hu>
	 <86802c440803301323q5c4bd4f4k1f9bdc1d6b1a0a7b@mail.gmail.com>
	 <20080330210356.GA13383@sgi.com>
	 <20080330211848.GA29105@one.firstfloor.org>
	 <86802c440803301629g6d1b896o27e12ef3c84ded2c@mail.gmail.com>
	 <20080331021821.GC20619@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2008 at 7:18 PM, Jack Steiner <steiner@sgi.com> wrote:
> >
>  > if the calling path like GET_APIC_ID is keeping checking if it is UV
>  > box after boot time, that may not good.
>  >
>  > don't need make other hundreds of machine keep running the code only
>  > for several big box all the time.
>  >
>  > YH
>
>
>  I added trace code to see how often GET_APIC_ID() is called. For
>  my 8p AMD box, the  function is called 6 times per cpu during boot.
>  I have not seen any other calls to the function after early boot
>  although I'm they occur under some circumstances.

then it is ok.

YH
