Return-Path: <linux-kernel-owner+w=401wt.eu-S1760938AbXJYHYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760938AbXJYHYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 03:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856AbXJYHYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 03:24:24 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:35925 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403AbXJYHYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 03:24:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=UoJUYvjk4Hq9WOgIyztF1lMQPp457srpOeupEknKB1Nv7TlujoWDQrSBd97JGDc9KOTf9UHwgNHoixWxIz3lQ1ge+pkJgPv2SAUs6RN4qfqlEXvDrRF2zfbNmXIlFglk51IY1ZXtfhrgegau/I6/aTdsFOEcDQrpJfi27LI+J+c=
Message-ID: <84144f020710250024q683cfff2ubd1f8bda75415e2c@mail.gmail.com>
Date: Thu, 25 Oct 2007 10:24:22 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [PATCH+comment] fix tmpfs BUG and AOP_WRITEPAGE_ACTIVATE
Cc: "Andrew Morton" <akpm@linux-foundation.org>, ezk@cs.sunysb.edu,
       ryan@finnie.org, mhalcrow@us.ibm.com, cjwatson@ubuntu.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, stable@kernel.org
In-Reply-To: <Pine.LNX.4.64.0710250705510.9811@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0710142049000.13119@sbz-30.cs.Helsinki.FI>
	 <200710142232.l9EMW8kK029572@agora.fsl.cs.sunysb.edu>
	 <84144f020710150447o94b1babo8b6e6a647828465f@mail.gmail.com>
	 <Pine.LNX.4.64.0710222101420.23513@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0710242152020.13001@blonde.wat.veritas.com>
	 <20071024140836.a0098180.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0710242233470.17796@blonde.wat.veritas.com>
	 <84144f020710242237q3aa8e96dtc8cf3f02f2af2cc9@mail.gmail.com>
	 <Pine.LNX.4.64.0710250705510.9811@blonde.wat.veritas.com>
X-Google-Sender-Auth: 125952db6c072a3f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On 10/25/07, Hugh Dickins <hugh@veritas.com> wrote:
> With unionfs also fixed, we don't know of an absolute need for this
> patch (and so, on that basis, the !wbc->for_reclaim case could indeed
> be removed very soon); but as I see it, the unionfs case has shown
> that it's time to future-proof this code against whatever stacking
> filesystems come along.

Heh, what can I say, after several readings, I still find your above
explanation (which I totally agree with) more to the point than the
actual comment :-).

In any case, the patch looks good to me.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

                                  Pekka
