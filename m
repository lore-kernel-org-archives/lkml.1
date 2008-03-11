Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbYCKOqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbYCKOqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 10:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYCKOp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 10:45:58 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:25926 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbYCKOp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 10:45:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GTZvS77IJhHmuNo6m9LoGjENP2S/fxNGUdusnKkEqA4WCse9NlVTkDTGvPoaZ2ejixXS57+yB+UnUF78s3E7lKiW7aecfGbz5nkcEDHFxeMisoZUUtr5A43Eh18O2ci4goZ1c8G4shO8+535t580ZLvUdGYaYNfoppP8pCHKKns=
Message-ID: <84144f020803110745jcc73368l84e2268b68133520@mail.gmail.com>
Date: Tue, 11 Mar 2008 16:45:48 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [RFC PATCH] Implement slub fastpath with sequence number
Cc: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Christoph Lameter" <clameter@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200803112041.09217.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080311093144.GB30220@Krystal>
	 <200803112041.09217.nickpiggin@yahoo.com.au>
X-Google-Sender-Auth: 53474a6e126980b7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Tue, Mar 11, 2008 at 11:41 AM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>  Wow. I applaud the effort to micro optimise things ;)
>
>  But I hope this doesn't get merged until macro-regressions in SLUB
>  are verified to be fixed. It's pretty clear that SLUB's problem is
>  not fastpath performance, so I think this would be premature
>  optimisation.

What regressions are you referring to? The SLAB_HWCACHE_ALIGN
regression patch you sent is being merged. What else?

And FWIW, I don't like the patch because it makes the code very hairy.
But I don't see why we shouldn't merge SLUB fast-path optimizations if
they're clean and you have the numbers to show it's a gain even if
there are other remaining regressions.
