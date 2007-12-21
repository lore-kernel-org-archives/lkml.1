Return-Path: <linux-kernel-owner+w=401wt.eu-S932100AbXLUBDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbXLUBDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 20:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758541AbXLUBDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 20:03:38 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:23695 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758459AbXLUBDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 20:03:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XquOGLFPZLdU1fgVJLc6p7rOa24eRG90yeWU3b3xfjdicyqRnt4MZZWz4pf78R/bD7+c2g/+mQlEeZbvRYYovDG02sE0EJ+YBIUFkzg6zSPaXRBOgFUm2M605zTzYqzIUIfxcxnrURbBu1AhIgICWdNalw5fqehssbfrray9BzQ=
Message-ID: <5d6222a80712201703v170d7datc3b364f168ad16ec@mail.gmail.com>
Date: Thu, 20 Dec 2007 23:03:36 -0200
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 0/5] x86: another attempt at x86 pagetable unification
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, "Andi Kleen" <ak@suse.de>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Jan Beulich" <jbeulich@novell.com>
In-Reply-To: <20071221005832.GB21860@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071219223534.129042140@goop.org>
	 <20071220094940.GA14227@elte.hu> <20071220112022.GA15832@elte.hu>
	 <476AD9EA.7010108@goop.org> <20071220213906.GB11897@elte.hu>
	 <476AE7D6.9000600@goop.org> <20071220222429.GA28029@elte.hu>
	 <476B0E59.5070503@goop.org> <20071221005832.GB21860@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 20, 2007 10:58 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
> > Well, testing for bisectability requires compiling each patch as its
> > applied, which gets painful for something like this where any change
> > will rebuild the world.  And dealing with patch conflicts caused by
> > changing early patches in the series is never fun.
>
> that's true. The 'rej' tool helps alot though. ( Plus a distcc cluster
> that builds a distro kernel in 45-50 seconds from scratch ;)


So that's your secret!


-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
