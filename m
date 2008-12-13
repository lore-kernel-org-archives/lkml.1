Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbYLMOV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbYLMOV7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 09:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755956AbYLMOVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 09:21:47 -0500
Received: from mail-bw0-f13.google.com ([209.85.218.13]:34234 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991AbYLMOVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 09:21:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UOkb1G73pug4VL/ObMMdX6RJVNoVwIxsMlerur6ySNvNDJRFc292iso8aR3Plarkjj
         +Jc4VefA6XF2Iohf+bc+MAZf2C6/MS9uPHNnL3niH8fifmxuXUgPt/gNOni/whZd4WO4
         ycLMlEi6Zw53wnNj/Pa84w4C/jIJLv2y5mOWc=
Subject: Re: Bugs on aspire one A150
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       ath5k-devel@venema.h4ckr.net, alsa-devel@alsa-project.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
In-Reply-To: <200812131435.34072.rjw@sisk.pl>
References: <491506DB.1070000@gmail.com>
	 <1229174138.24940.9.camel@maxim-laptop>  <200812131435.34072.rjw@sisk.pl>
Content-Type: text/plain
Date: Sat, 13 Dec 2008 16:21:37 +0200
Message-Id: <1229178097.4936.1.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-12-13 at 14:35 +0100, Rafael J. Wysocki wrote:
> On Saturday, 13 of December 2008, Maxim Levitsky wrote:
> > 
> > So, big thanks for everything.
> > 
> > Now aspire one linux support is very close to perfect,
> > (only problem left is that wireless is limited to 18Mbits/s raw rate,
> > but at some point I or developers of ath5k will get to the bottom of
> > this)
> > 
> > I also noticed, that now the SD only card reader is always enabled
> > regardless of card been there while booting, and same happens in
> > windows, I suspect that this is permanent hardware change, which worries
> > me, but this reader works fine otherwise.
> > (This is another reason why binary bioses are evil, go and find out why
> > it enables it)
> > 
> > 
> > Also forgot to mention that both readers ignore write protect tab on SD
> > card, and I will report this to correct mailing list soon.
> > Everything else works fine
> > 
> > please include acpiphp fix in 2.6.28.
> 
> Which one is this?



acpiphp: Identify more removable slots
    
    According to section 6.3.6 of the ACPI spec, the presence of an _RMV
    method that evaluates to 1 is sufficient to indicate that a slot is
    removable without needing an eject method. This patch refactors the
    ejectable slot detection code a little in order to flag these slots as
    ejectable and register them. Acpihp therefore binds to the expresscard
    slot on my HP test machine.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>


this makes acpiphp handle hotplug of (now one, sd reader is somehow
always present) card reader.


Best regards,
	Maxim Levitsky

