Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbYJISJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbYJISJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 14:09:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbYJISIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 14:08:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:54529 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbYJISIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 14:08:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=XCKjA17ddPWzkqtYFnx5//6W6MO5gAK/gL9v3j/0oOecACHxEz3HbIOxeY0gzQVmhw
         3YWB8bN2qXEzf1zs9LHOYDlkRhOw1qr2yCbG8T1P09e5UzPC3yYv8IIofTXkKH9z9nbw
         h9PKhOr5LS2l6hzj08CIVYLzJh6WUwYSoI0OM=
Message-ID: <86802c440810091108w706c5382p6a7b283ba2ebe2b1@mail.gmail.com>
Date: Thu, 9 Oct 2008 11:08:46 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Randy Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/3] x86: mtrr_cleanup update command line
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081009102049.c22cf670.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222817380-29481-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080930165739.7847be37.rdunlap@xenotime.net>
	 <20081008170751.6d86b8e2.rdunlap@xenotime.net>
	 <86802c440810081828m2b9210e6y81503bdffe12fb03@mail.gmail.com>
	 <20081009102049.c22cf670.rdunlap@xenotime.net>
X-Google-Sender-Auth: cec8435e564ab1a5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2008 at 10:20 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Wed, 8 Oct 2008 18:28:39 -0700 Yinghai Lu wrote:
>
>> On Wed, Oct 8, 2008 at 5:07 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> > On Tue, 30 Sep 2008 16:57:39 -0700 Randy Dunlap wrote:
>> >
>> > BTW, this comment is alread in Documentation/kernel-parameters.txt, at the top of the file:
>>
>> oh...
>>
>> >
>> > The following is a consolidated list of the kernel parameters as implemented
>> > (mostly) by the __setup() macro and sorted into English Dictionary order
>> > (defined as ignoring all punctuation and sorting digits before letters in a
>> > case insensitive manner), and with descriptions where known.
>> >
>> >
>> how about
>>
>> like to filter out disable, enable, no, etc...
>
> I don't think that mtrr gets any special treatment here.
> All "acpi" parameters are not grouped together (unless they begin with
> "acpi").  All "apic" parameters are not grouped together.
> All "*iommu*" parameters are not grouped together....

could adjust acpi iommu to same layout

YH
