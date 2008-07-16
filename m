Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbYGPDc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbYGPDc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 23:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbYGPDcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 23:32:21 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:15685 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbYGPDcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 23:32:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=crimOitJP3+u5+MEnKYrDjwFXcaPw3QjzGW1Fp10pdD9ZkedDBP/akhtmUiZAnm7+R
         AsdGNFDdhyWZmEn37u9I30smc0X95ix1UKLUkZcKMEqwVejsKZPw3D0uwgUEaT2z8aF7
         uBApNCB3yKiasXZMuMowRwT/s/jDm49E372U8=
Message-ID: <3aa654a40807152032t774e1182vee32a1d3d381719a@mail.gmail.com>
Date: Tue, 15 Jul 2008 20:32:19 -0700
From: "Avuton Olrich" <avuton@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: s2disk: system powers up again after power off
Cc: "Martin Michlmayr" <tbm@cyrius.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200807160132.38814.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080715124733.GA4111@deprecation.cyrius.com>
	 <200807160059.54886.rjw@sisk.pl>
	 <3aa654a40807151609m70d6852ex7f85d60c438bb4d7@mail.gmail.com>
	 <200807160132.38814.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 4:32 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, 16 of July 2008, Avuton Olrich wrote:
>> On Tue, Jul 15, 2008 at 3:59 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Wednesday, 16 of July 2008, Avuton Olrich wrote:
>> >> On Tue, Jul 15, 2008 at 1:24 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> > On Tuesday, 15 of July 2008, Avuton Olrich wrote:
>> >> >> On Tue, Jul 15, 2008 at 5:47 AM, Martin Michlmayr <tbm@cyrius.com> wrote:
>> >> >> > When I use s2disk to suspend my HP 2510p notebook, it writes
>> >> >> > everything to disk, and powers off... but after 2-3 seconds it often
>> >> >> > powers on again.  This doesn't happen all the time but quite
>> >> >> > frequently (definitely in the majority of cases).
>> >> >> >
>> >> >> > I believe I've never seen this when I use "halt" to power off the
>> >> >> > machine (but I don't use halt very often).
>> >> >> >
>> >> >> > Any idea?
>> >> >>
>> >> >> Ugh, this happens here too, this started occuring before 2.6.25 but
>> >> >> every time I try to bisect it takes hours and I end up screwing up
>> >> >> somewhere along the way, so I haven't had time to bisect this
>> >> >> correctly.
>> >> >
>> >> > Please try to put "shutdown method = shutdown" into the s2disk's configuration
>> >> > file and see what happens in that case.
>> >>
>> >> Anything a little less fancy? I use pm-hibernate, or gnome's Power
>> >> Manager to hibernate; I don't even have s2disk installed, sorry I
>> >> should have mentioned that.
>> >
>> > Martin mentioned s2disk in his original post.  Never mind.
>> >
>> > Please try to do "echo shutdown > /sys/power/disk" before hibernation and
>> > see what happens.
>>
>> Well, that certainly works (powers off as expected). Should I be
>> putting this in my startup scripts or is there something I need to do
>> to help fix this problem, kernel-wise?
>
> BTW, is the problem also present in linux-next?

No, it appears to be fixed in linux-next, thanks!
-- 
avuton
--
 "I've got a fever. And the only prescription is more cowbell." --
Christopher Walken
