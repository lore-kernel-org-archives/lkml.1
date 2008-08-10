Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbYHJI2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbYHJI2U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 04:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbYHJI2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 04:28:04 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:41809 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbYHJI2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 04:28:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OWuSoidP4oxjGAiyC7ndr8FkV2P9rK85pR/+NQEEzU5KUCCahe/Xdh5hQPOfTpZYc0
         Id6b/9hHXmcdjrqfxgMxoIm8zv7NGS8idV1BUwpuMOH93t+ynOQqIlJ2Ll6XswkMWeLz
         beEQBvKzTx0kM2fkBcWb1K4tP/TotwWBkXTug=
Message-ID: <514e099a0808100128u303207clcb22292db2f0cc59@mail.gmail.com>
Date: Sun, 10 Aug 2008 01:28:00 -0700
From: "S K" <nospamnoham@gmail.com>
To: "Thomas Renninger" <trenn@suse.de>
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Cc: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Zhao Yakui" <yakui.zhao@intel.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <200808092059.47863.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com>
	 <200808081430.43012.trenn@suse.de>
	 <aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com>
	 <200808092059.47863.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 9, 2008 at 11:59 AM, Thomas Renninger <trenn@suse.de> wrote:
> On Friday 08 August 2008 08:23:25 pm S K wrote:
>> > Try updating the BIOS.
>> > I expect your CPU is too new and the BIOS cannot export the correct freq
>> > values for the specific CPU yet.
>> >
>> >      Thomas
>>
>> The BIOS is already at the latest version :( Is the above comment the
>> only possible reason for the issue?
>
> It is very likely.

But Windows XP is able to do the scaling properly. So how can it be a
BIOS issue? While reading about the Foxconn BIOS fiasco that happened
recently a kernel dev (forgot his name) stated that Linux tries to
emulate Windows for ACPI operations.

So I'm guessing this is a kernel bug.

-SK
