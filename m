Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbXFUPrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbXFUPrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 11:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbXFUPrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 11:47:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbXFUPrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 11:47:24 -0400
Message-ID: <467A9D67.8060504@redhat.com>
Date: Thu, 21 Jun 2007 11:46:47 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ian McDonald <ian.mcdonald@jandi.co.nz>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Andi Kleen <ak@suse.de>, Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       William Cohen <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       Ville Syrj?l? <syrjala@sci.fi>, Jean Delvare <khali@linux-fr.org>,
       Rudolf Marek <r.marek@assembler.cz>, Soeren Sonnenburg <kernel@nn7.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches
References: <467543FA.60905@googlemail.com>  <5640c7e00706201508g3c1fc40eq82a1db05c9156b5d@mail.gmail.com>  <alpine.LFD.0.98.0706201536161.3593@woody.linux-foundation.org> <5640c7e00706201541g3ecaf8c5i524d8b464d8fcc2d@mail.gmail.com> <alpine.LFD.0.98.0706201550480.3593@woody.linux-foundation.org> <alpine.LFD.0.98.0706201601100.3593@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706201601100.3593@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2007 07:04 PM, Linus Torvalds wrote:
> As far as I know, the biggest reason to use DEBUG_RODATA is
> 
>  (a) Hey, it's a cheap way to check one thing
> 
>  (b) An added layer of security (which it's not that great for, but it 
>      might make sense to make it more of a real security feature).
> 

And as a security feature it's pretty useless if kprobes are allowed.
