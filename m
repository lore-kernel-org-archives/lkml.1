Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbYJWOze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbYJWOze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYJWOzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:55:25 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:14813 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbYJWOzY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:55:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wPzYcHSnbgdF/mc1b6Y5gHyWxY8ElLDUxMo95HheS1mXXIoDleeifumkYzstZOdQKq
         ynlXK9F8VLHgUZn3nMMtejOq2nTYwL87I3rZxxV5MFdvOESrNp/ZHYKvPkQSNehvR+WI
         bv6Bc5jK17nyBw2DkxX6y4bNcf80inGeQV4DQ=
Message-ID: <53cc795f0810230755q4eac0111y4d2366d1ac99b741@mail.gmail.com>
Date: Thu, 23 Oct 2008 18:55:23 +0400
From: sbs <gexlie@gmail.com>
To: "Alistair John Strachan" <alistair@devzero.co.uk>
Subject: Re: high %CPU values after upgrading to the last stable kernel
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200810230155.48344.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <53cc795f0810221237u1b5ece4dq477be67903dd5879@mail.gmail.com>
	 <c62985530810221404k2987da81q3e158e203c379b89@mail.gmail.com>
	 <2c0942db0810221540l4da55d92n2b55124908d08d3@mail.gmail.com>
	 <200810230155.48344.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thank you
will be waiting until it gets fixed

On Thu, Oct 23, 2008 at 4:55 AM, Alistair John Strachan
<alistair@devzero.co.uk> wrote:
> On Wednesday 22 October 2008 23:40:54 Ray Lee wrote:
>> On Wed, Oct 22, 2008 at 2:04 PM, Frédéric Weisbecker <fweisbec@gmail.com>
> wrote:
>> > 2008/10/22 sbs <gexlie@gmail.com>:
> [snip]
>> >> should i upgrade procps or downgrade kernel then to get proper values
>> >> back? :) or is it a feature of the new kernel?
>> >>
>> >> thank you
>> >
>> > Hi,
>> >
>> > It really depends on what your box is doing at the time you capture
>> > the cpu usage.
>> > And it really depends too of your kernel config...
>>
>> It really shouldn't, we're talking about /proc which is supposed to be
>> a stable userspace interface.
>>
>> Try upgrading your procps, there's a chance it's just so ancient that
>> it accidentally got broken. However, if that fixes your problem, then
>> please report back with a subject line of "/proc API breakage" or
>> somesuch, to get the proper attention to the issue.
>
> This is a known kernel bug that for some reason wasn't fixed before 2.6.27 was
> released. See http://bugzilla.kernel.org/show_bug.cgi?id=11209 for details.
>
> It would probably be useful if the OP added himself to the CC list, so Peter
> can get some more details about the box.
>
> --
> Cheers,
> Alistair.
>
