Return-Path: <linux-kernel-owner+w=401wt.eu-S965558AbXJQVLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965558AbXJQVLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 17:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbXJQVLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 17:11:32 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:52312 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757195AbXJQVLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 17:11:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=tn7mrr6TguPPraA6q+IsgXKX6BnupysY0Py/W5znDy+sZGWf8Onatix9AAdkaGFSv4Gap6mB2EcT5H0nBkG07wJMufFPGy+1MVd84FlNN6xrtbtuM6R2h6nZCiWzlQsZoO9B3JUWJCVHyRpdnsD8F64m7FeqbInlYIAYlPJvSNQ=
Message-ID: <75b66ecd0710171411n55efdb5bt8e9627301ed9088e@mail.gmail.com>
Date: Wed, 17 Oct 2007 17:11:30 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: VM question - accounting of SysV SHM
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20071017165857.08b887e9@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <75b66ecd0710171349n2a2a5922qfc0d8bb64980a15c@mail.gmail.com>
	 <20071017165857.08b887e9@bree.surriel.com>
X-Google-Sender-Auth: 1e2e3feb0266caba
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/07, Rik van Riel <riel@redhat.com> wrote:
> On Wed, 17 Oct 2007 16:49:07 -0400
> "Lee Revell" <rlrevell@joe-job.com> wrote:
>
> > Sorry to ask this question on the list but I've Googled and found
> > nothing.
> >
> > Is system V shared memory accounted for as Cached, or as normal
> > application memory?
>
> Cached.
>
> Shared memory segments basically are tmpfs files.

Thanks!

Are there any plans to track it separately in a future kernel release?

I've also noticed that if huge pages are used for the shared memory,
they are not accounted for as cached - I have a 56GB huge page pool
but cached is only 6GB.  Is this behavior specific to huge pages?

Finally, are these quirks documented anywhere?

Lee
