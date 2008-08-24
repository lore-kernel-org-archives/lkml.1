Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbYHXDon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbYHXDon (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 23:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYHXDoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 23:44:34 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:64530 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbYHXDod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 23:44:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HCb68VchpmnLB4B/taDyhyqTshUEsbQ0/lIetEpc67dpCFmNrD6BxQpVRmiR1DKak7
         yB23lyQG7MQflBTpClEfnvlhsgYv7KwrwMeY4vkB2wwSmroPfM8VaXypYSjlx6oAXRlc
         EMjY41KcZFAzt0FOBTxf/IdXX/IW0Kh0DTsp0=
Message-ID: <86802c440808232044i1670857bx194f4944bff6080a@mail.gmail.com>
Date: Sat, 23 Aug 2008 20:44:32 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <558013.68193.qm@web82107.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <558013.68193.qm@web82107.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2008 at 7:39 PM, David Witbrodt <dawitbro@sbcglobal.net> wrote:
>
>
>> > (BTW, just what kernel version were you using for those patches?  The
>> > v2.6.27-rcX series place the patch's changes over 100 lines earlier
>> > than the line numbers indicated in your patches....)
>>
>> we are working on tip/master
>
> My mistake... sorry.  Previously, Ingo had me doing things with tip/master,
> but usually you had me working with v2.6.27-rc3.  I should have tried
> tip/master as soon as I saw the discrepancy.
>
>
> I have some questions about what happens next:
>
> - This fix will naturally make it into v2.6.27, maybe even as soon
> as v2.6.27-rc5, correct?
yes.
>
> - Is there any chance I can get it into the stable 2.6.26.X updates?
> (Who should I ask, or are only developers allowed to lobby for this
> sort of thing?)

after the patch get into linus tree. Greg will put the patch into 2.6.26.X

>
> - Are you worried about the potential problems of a quirk-based approach?
> What if many more people experience a similar regression once 2.6.26 or
> later appears in their distribution?  I'm sure you don't want to have to
> write a different quirk for each individual's hardware, and this problem
> did not arise with the approach used for resource management in 2.6.25.

this patch should be safe.

2.6.26 is fixing one bug about reserving local apic address and that
in e820 table.
and it reveals one bios bug.

YH
