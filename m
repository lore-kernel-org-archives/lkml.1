Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbYKUQdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbYKUQdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbYKUQdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:33:11 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:26351 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbYKUQdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:33:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=J4aQK6MVbIrmwH3aKY01QJUt4UOPcBeenFqypFXRXKHeqCA46M8gjhizYbAujr7+It
         /DOwUZqhzUuzP2CDPBTWaX0hinLmTjduPOrIvLQp7Oui7/h9srl0m8Dmy50pkngEr3is
         OjRPZuHq1ziJygRzVVUOFQoUOvNSPOeakSMfs=
Message-ID: <7c86c4470811210833l5c8005b4l675bc51df50affaa@mail.gmail.com>
Date: Fri, 21 Nov 2008 17:33:07 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Subject: Re: debugctl msr
Cc: "Markus Metzger" <markus.t.metzger@googlemail.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E08F3B93D@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <7c86c4470811190913u743706abgafff3b0f0e3559ec@mail.gmail.com>
	 <1227119245.6025.12.camel@raistlin>
	 <7c86c4470811191120i63b70970s3e24af5c962ea538@mail.gmail.com>
	 <1227133570.6104.10.camel@raistlin>
	 <7c86c4470811201319x2eb93d41vbdd8ce480a797fab@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F115BC@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811210538i5e6958e1p2c31effa762f5914@mail.gmail.com>
	 <7c86c4470811210727o13006d5bk5bcbacb791e51b1c@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F3B93D@irsmsx504.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 5:10 PM, Metzger, Markus T
<markus.t.metzger@intel.com> wrote:
>>-----Original Message-----
>>From: stephane eranian [mailto:eranian@googlemail.com]
>>Sent: Freitag, 21. November 2008 16:27
>>To: Metzger, Markus T
>>Cc: Markus Metzger; Ingo Molnar; Andi Kleen; Andrew Morton;
>>linux-kernel@vger.kernel.org
>>Subject: Re: debugctl msr
>
>>The absolute maximum MUST be at buffer+size+1 but the
>>threshold can be anywhere
>>between the start of the buffer and buffer+size. You had it set past
>>the end of the buffer (at +1),
>>therefore PEBS was not generating any interrupts.
>
> The default is cyclic mode, which requires the interrupt threshold
> to be outside of the buffer.
>
That's not what I need.

> A request for interrupt mode should have got you -EOPNOTSUPP.

I did not try that.

>
> Absolute max should be one byte beyond the buffer, which
> is base + size.
>
My bad ;-<
