Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbYDISCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbYDISCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 14:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbYDISC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 14:02:27 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:32867 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbYDISC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 14:02:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FoX0EttJ9RLNwDb4cosFxK++z2cWXq94QoQWhaJW/FKfed5yZjBAYW2cqotgwBYWXVNEaA47u1P204m/OJ673TkRRJEfXUnp0/iT8SyVaN6m/adIqhvAY33Aw9s/YBRFw/0O7yJNUbmRpM/sETf76wnmEthtevajUhTKucMdlXA=
Message-ID: <86802c440804091102w410bc6f4v7a848b1328c2bbbd@mail.gmail.com>
Date: Wed, 9 Apr 2008 11:02:22 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: Does Linux have plan to support memory hole remapping?
Cc: "Arne Georg Gleditsch" <arne.gleditsch@dolphinics.no>,
       "Zhao Forrest" <forrest.zhao@gmail.com>, discuss@x86-64.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de
In-Reply-To: <20080409100331.GH19010@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ac8af0be0804090054w47f48ddel387d80a0331d16e1@mail.gmail.com>
	 <87iqyro3rc.fsf@basil.nowhere.org>
	 <kjmr6dfxsqf.fsf@pelargir.dolphinics.no>
	 <20080409100331.GH19010@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2008 at 3:03 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> On Wed, Apr 09, 2008 at 11:50:00AM +0200, Arne Georg Gleditsch wrote:
>  > Andi Kleen <andi@firstfloor.org> writes:
>  >
>  > > "Zhao Forrest" <forrest.zhao@gmail.com> writes:
>  > >>
>  > >> As we can see from above information that the physical memory in system
>  > >> is 32768MB(32GB). However OS is only using about
>  > >> (32768-512)MB(MemTotal:     33010240 kB). Does this mean that this
>  > >> linux kernel can't use the physical memory remapped
>  > >> from (4G-512M, 4G) to (32G, 32G+512M)?
>  > >
>  > > The linux kernel can only use the memory passed to it by the BIOS.
>  > > Sometimes they need special BIOS setup options to enable remapping. If
>  > > there are no such options and you can't upgrade it you're out of luck
>  >
>  > Hm, wouldn't the given e820 map and mtrr listing indicate that 512M were
>  > actually remapped to 32G+ in this case?
>
>  The way it usually works (if it is implemented correctly in the BIOS)
>  is that all memory starting at the hole moves up together
>  (often subject to DIMM boundaries etc.),
>  not that the area below the hole is remapped individually.
>
>  BTW it is not actually 512MB that is lost. MemTotal does not
>  include mem_map and that alone is ~512MB (64 bytes for each 4K page)
>
>  So as far as I can see there is no missing memory remapping in Zhao's case,
>  he's just confused by the MemTotal semantics.

agreed. the HW/BIOS already enable HW memory hole.

YH
