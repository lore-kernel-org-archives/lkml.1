Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbYKERdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbYKERdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 12:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbYKERdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 12:33:38 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:4773 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbYKERdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 12:33:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CN1G2sgwDkF1bjV3jvSBiF+1n0+c4JFBmgpsbVsC77qM0G+3cWYWKJb18ILXpL2SZg
         LY54ktPI4Uc96KbtEMKqs9OSvrco53P46eGRFbcEIQ46iH0CeR3mjcdKI3oxjzOZlQCo
         i+zAH3ZpJAk5GFhLIUx25rTGhIXbeJp4xY/Rc=
Message-ID: <8bd0f97a0811050933m13addb7eiddb963bfdf4d7416@mail.gmail.com>
Date: Wed, 5 Nov 2008 12:33:37 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH] UIO: only call pgprot_noncached if defined
Cc: "Hans J. Koch" <hjk@linutronix.de>, "Mike Frysinger" <vapier@gentoo.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081105163334.GA8473@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225301177-21406-1-git-send-email-vapier@gentoo.org>
	 <20081105113610.GA6382@local> <20081105163334.GA8473@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 11:33, Greg KH wrote:
> On Wed, Nov 05, 2008 at 12:36:11PM +0100, Hans J. Koch wrote:
>> There seem to be archs that cannot easily implement a sensible
>> pgprot_noncached() function, so we should merge this patch. UIO doesn't
>> compile on these archs right now.
>
> No, we should fix those arches to have that function at least NULLed
> out.  Isn't there only one, Blackfin?  Putting #ifdefs in .c files is
> not something we really want to do if at all possible.

that was my question.  this function isnt documented.  if the hardware
doesnt support it, is the right thing really for the arch to lie to
drivers and not actually give back cached settings even though it
asked for non-cached ?
-mike
