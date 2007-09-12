Return-Path: <linux-kernel-owner+w=401wt.eu-S1764122AbXILUUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764122AbXILUUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 16:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763372AbXILUUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 16:20:06 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:10588 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763301AbXILUUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 16:20:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=H/dP21toIcr33x73TrAHS+GJ+dQMcrP0suoHODuP0Hbz1mCUD2XAlK6QJ75ZGtrlGt3q/f+iGQgvvKeCYwAFH9L4xPKWs+wST36lUsCLX5PabJHJ42XdannYhDzYxal1+Q08w/ZTFm8sJkm9C0AIIg/YSMaY+B21vp0grgAVOAw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0/4] build system: section garbage collection for vmlinux
Date: Wed, 12 Sep 2007 21:19:57 +0100
User-Agent: KMail/1.9.1
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
References: <200709112105.34301.vda.linux@googlemail.com> <p73veagykwv.fsf@bingen.suse.de>
In-Reply-To: <p73veagykwv.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709122119.57661.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 September 2007 22:03, Andi Kleen wrote:
> Denys Vlasenko <vda.linux@googlemail.com> writes:
> > 
> >    text    data     bss     dec     hex filename
> > 5159478 1005139  406784 6571401  644589 linux-2.6.23-rc4.org/vmlinux
> > 5131822  996090  401439 6529351  63a147 linux-2.6.23-rc4.gc/vmlinux
> > 
> > In this particular case, 402 objects were discarded, saving 42 kb.
> 
> I wonder how many of those are 100% unused on all configurations? 
> That could be an useful janitor task to clean up

With CONFIG_DISCARD_UNUSED_SECTIONS=y ld will helpfully flood you
with the list of discarded stuff. I pass --print-gc-sections to it.
--
vda
