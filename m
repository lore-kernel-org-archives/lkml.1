Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbZJaOG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbZJaOG0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 10:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757763AbZJaOGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 10:06:25 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:38335 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757746AbZJaOGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 10:06:24 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, yakui.zhao@intel.com,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [linux-pm] intermittent suspend problem again
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <200910301918.53301.rjw@sisk.pl>
	<87k4yc3drd.fsf@tac.ki.iif.hu> <200910302138.37938.rjw@sisk.pl>
	<9b2b86520910310502p7fe8e0edmff09220632fab5e2@mail.gmail.com>
Date: Sat, 31 Oct 2009 15:06:05 +0100
In-Reply-To: <9b2b86520910310502p7fe8e0edmff09220632fab5e2@mail.gmail.com>
	(Alan Jenkins's message of "Sat, 31 Oct 2009 12:02:02 +0000")
Message-ID: <874opfwtde.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins <sourcejedi.lkml@googlemail.com> writes:

> On 10/30/09, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Friday 30 October 2009, Ferenc Wagner wrote:
>>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>>>
>>>> On Thursday 29 October 2009, Ferenc Wagner wrote:
>>>>
>>>>> and saving the image as well.  If s2disk didn't report funny huge
>>>>> negative ratios all the time,
>>>>
>>>> Hmm.  This looks like a bug in s2disk.
>>>
>>> Definitely.  Do you also experience this?
>>
>> Not really, but I use newer versions.
>>
>>> Probably an easy one, but I've never had the chance to check the CVS
>>> version (running 0.7 at the moment).  I can probably give 0.8 a spin
>>> if you deem necessary.  I always thought it wasn't more than a
>>> cosmetic flaw.
>>
>> It probably is.  You can try the current version from my git tree at:
>> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-utils.git
>
> I seem to recall reporting this and finding that the latest version
> fixed the bug simply by removing the code which printed the ratio :-).

Heh, maybe, but the version compiled from Rafael's git tree prints the
ratio all right, and its value is even positive and less than 1.  So I
confirm that the ratio issue is fixed.  I'll be running with this
version from now on, and if it exhibits the same original issue, I'll
switch to shutdown mode and gather some experience running that.
-- 
Thanks,
Feri.
