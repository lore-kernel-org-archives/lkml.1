Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbXEWIhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbXEWIhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 04:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763023AbXEWIhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 04:37:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:12127 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762888AbXEWIhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 04:37:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=J9g9Z+y8n4Dt/SMJ37huvD9ocJcSZZF8iqC1038okLL9yo+bs6e3FHzPxtOBLqJKXbVcCwr4CvO5Fdws/OzmxuMME1MxjQQvvh8+BozSiv3XyyFX8X2ukELjBZXOtD1E435BAS6VIxOUgJ6uDnLh7wPkinwLNeDl5XSQLhOMUt4=
Message-ID: <a781481a0705230137v4c8ba82fx263212a2958b55b9@mail.gmail.com>
Date: Wed, 23 May 2007 14:07:19 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: Re: any value to "NORET_TYPE" macro?
Cc: "Robert P. J. Day" <rpjday@mindspring.com>, "Adrian Bunk" <bunk@stusta.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <m37ir0iodl.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
	 <20070522135927.GA2098@stusta.de>
	 <Pine.LNX.4.64.0705221002350.14457@localhost.localdomain>
	 <20070522161951.GC2098@stusta.de> <m3ejl8k6e3.fsf@maximus.localdomain>
	 <Pine.LNX.4.64.0705221616270.18792@localhost.localdomain>
	 <m37ir0iodl.fsf@maximus.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/07, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> "Robert P. J. Day" <rpjday@mindspring.com> writes:
>
> > that may be but, as i suggested earlier, that would get into guessing
> > what those developers were thinking, and i just didn't want to go
> > there.
>
> No guessing, I just checked it (though a second check wouldn't do
> any harm).
>
> > the simple version of the patch is now in andrew's tree, and i'll
> > worry about the harder stuff next time.
>
> The "next time" would be much harder as there would be no key for
> searching for these functions.

Krzysztof's absolutely right ... we don't want to lose the NORET_TYPE
annotations on all these functions before we switch them to
ATTRIB_NORET. And yes, _all_ of these NORET_TYPE's do want
to be ATTRIB_NORET (except for those that are double-annotated,
for those we can just get rid of the NORET_TYPE macro).
