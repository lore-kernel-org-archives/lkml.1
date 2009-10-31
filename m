Return-Path: <linux-kernel-owner+w=401wt.eu-S932458AbZJaMCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbZJaMCD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 08:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932140AbZJaMCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 08:02:01 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58678 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbZJaMCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 08:02:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NGqENCph8zKg+yxhjlDnMM/cg4KydXRLexdrPF+1BCrHpC+gdD0t1vomGY9eqX15ez
         N/FHfER3+2N+Nq8k7iZ//o8KtnAsEb98URx1sGUQ5njrvGLvxcfYwxOSTUnfvawOOaau
         H0eWXKBjF4rm0WQOXc+UMasZQHbToCozHGDjI=
MIME-Version: 1.0
In-Reply-To: <200910302138.37938.rjw@sisk.pl>
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <200910301918.53301.rjw@sisk.pl>
	 <87k4yc3drd.fsf@tac.ki.iif.hu> <200910302138.37938.rjw@sisk.pl>
Date: Sat, 31 Oct 2009 12:02:02 +0000
Message-ID: <9b2b86520910310502p7fe8e0edmff09220632fab5e2@mail.gmail.com>
Subject: Re: [linux-pm] intermittent suspend problem again
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ferenc Wagner <wferi@niif.hu>, linux-pm@lists.linux-foundation.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, yakui.zhao@intel.com,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/09, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday 30 October 2009, Ferenc Wagner wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>>
>> > On Thursday 29 October 2009, Ferenc Wagner wrote:
>> >
>> >> "Rafael J. Wysocki" <rjw@sisk.pl> writes:

>> >> and saving the image as well.  If s2disk didn't report funny huge
>> >> negative
>> >> ratios all the time,
>> >
>> > Hmm.  This looks like a bug in s2disk.
>>
>> Definitely.  Do you also experience this?
>
> Not really, but I use newer versions.
>
>> Probably an easy one, but I've never had the chance to check the CVS
>> version
>> (running 0.7 at the moment).  I can probably give 0.8 a spin if you deem
>> necessary.  I always thought it wasn't more than a cosmetic flaw.
>
> It probably is.  You can try the current version from my git tree at:
> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-utils.git
>
> Thanks,
> Rafael

I seem to recall reporting this and finding that the latest version
fixed the bug simply by removing the code which printed the ratio :-).

Regards
Alan
