Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYCBC1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYCBC1U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 21:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbYCBC1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 21:27:11 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:35572 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYCBC1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 21:27:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hA2sXOXH5UKqV1STJccrrnQpZwb3UXPibx7yNp6tWnrC689UG89T56rW60zq5dmJK+FGGReBg8OeqmBuE2L0qaAb+FNqJeyGFhSfbHaWuwT0kqj2TRr7twOZ3Mu4SE7JK3CHKDM1cpXx+RqlhiLY9rLPK0IQLrN2MgwwyhKfyL4=
Message-ID: <75b66ecd0803011827qd64e1f2ud593fedbec33abe9@mail.gmail.com>
Date: Sat, 1 Mar 2008 21:27:09 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Pierre Ossman" <drzeus-list@drzeus.cx>
Subject: Re: [RFC][PATCH] cpuidle: avoid singing capacitors
Cc: "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Adam Belay" <abelay@novell.com>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080229193812.31f45b0c@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080229193812.31f45b0c@mjolnir.drzeus.cx>
X-Google-Sender-Auth: c5dbcc786645d346
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 1:38 PM, Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> Many devices today are of a less than stellar quality, and singing
>  transistors are a common problem. A high-pitch noise is created, caused
>  by power fluctuations as the processor enters and leaves deep sleep at
>  a high frequency.
>
>  Instead of just disabling the deep sleep (which wastes power). This
>  patch merely reduces the number of times it is entered so that the
>  frequency doesn't exceed 500 Hz. That should make sure the problem is
>  inaudible.

Should there be a comment stating the motivation for the change?

Thanks for trying to address this problem, I know many users who are afflicted.

Lee
