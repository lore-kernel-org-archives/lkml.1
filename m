Return-Path: <linux-kernel-owner+w=401wt.eu-S1760260AbZAMNa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260AbZAMNa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbZAMNaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:30:14 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:31395 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbZAMNaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:30:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PF25NCgQ+Fn3auf+4TDLOWa26lL/NXU/xoLTSmlI/yQhW+SvYK1jEL+r+4xcFjsuwH
         7n/1Ti+bHxJwSezbaFQRxemKracZpc1KrYY8vOn1UZhLfyiOtVAZdNNTiKsd6dTAF+6H
         FAI9QsmfaIsPV/+0i5pTIwQUJmG9+M5VuPhg4=
Message-ID: <b6a2187b0901130530y346f2526l220ea410dd95ea91@mail.gmail.com>
Date: Tue, 13 Jan 2009 21:30:10 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #12422] 2.6.28-git can't resume from str
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Christian Borntraeger" <borntraeger@de.ibm.com>,
       "Daniel Drake" <dsd@gentoo.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Phil Dibowitz" <phil@ipom.com>,
       "Alan Stern" <stern@rowland.harvard.edu>
In-Reply-To: <200901131232.17941.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
	 <b6a2187b0901122028w3f85fc9aj41d7c8ac44adb2ed@mail.gmail.com>
	 <b6a2187b0901122147o45890cd4lfb6ba7b2908e6ae7@mail.gmail.com>
	 <200901131232.17941.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 7:32 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday 13 January 2009, Jeff Chua wrote:
>> On Sun, Jan 11, 2009 at 7:16 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>
>> > The following bug entry is on the current list of known regressions
>> > from 2.6.28.  Please verify if it still should be listed and let me know
>> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12422
>> > Subject         : 2.6.28-git can't resume from str
>> > Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
>> > Date            : 2009-01-10 1:39 (2 days old)
>> > References      : http://marc.info/?l=linux-kernel&m=123155157909282&w=4
>>
>> Fixed by reverting a0d4922da2e4ccb0973095d8d29f36f6b1b5f703.
>> 7503bfbae89eba07b46441a5d1594647f6b8ab7d has already been reverted in
>> the Linus's latest git tree.
>
> Can you please check if the issue goes away ...
> instead of reverting commit a0d4922da2e4ccb0973095d8d29f36f6b1b5f703

Confirmed. This commit works. STR still ok.

But now, a different problem. STD "almost" ok. Suspend-to-disk hangs
after counting to 100%. Power-cycle and boot ok able to resume. ...
Again, this is another problem with/without your latest patch. Another
issue is with iwl4965 not able to attach to my hidden AP. Will try to
bisect soon.

Thanks for the patch.

Jeff.
