Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbYGPOOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbYGPOOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756444AbYGPON5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:13:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:49588 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009AbYGPON4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:13:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Vyn4t313C65sgt1IPJiL3TNJ1YXkWcGiN7QftpbyN/vcrxyulxzdojfBXbkW07hE1Q
         cAt4Ma1UcMQEM5fbbyXaFCgJ7TEVYlONggLHY8CH50Os4uoSlQ0BeRNgeIesPQm2WNmq
         Khd3s7sSBIAmLCOGaVVRsZtko2yfM+/yoy31I=
Message-ID: <cb0375e10807160713r5aa2bb82md1e0b3b349ca8115@mail.gmail.com>
Date: Wed, 16 Jul 2008 10:13:54 -0400
From: "Andrew Lutomirski" <luto@myrealbox.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
Cc: "Andi Kleen" <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>, "Ingo Molnar" <mingo@elte.hu>,
       public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@lo.gmane.org,
       "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "pm list" <linux-pm@lists.linux-foundation.org>,
       "Pavel Machek" <pavel@ucw.cz>
In-Reply-To: <487AD37A.2050903@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807010148.02135.rjw@sisk.pl> <487A2431.2050103@myrealbox.com>
	 <487A4CB7.1080001@firstfloor.org> <200807132115.08230.rjw@sisk.pl>
	 <487A617B.80707@firstfloor.org> <487A67C3.50000@zytor.com>
	 <487AD37A.2050903@zytor.com>
X-Google-Sender-Auth: f073bf8317ba1746
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay in testing.  This appears to work and fix the problem.

--Andy

On Mon, Jul 14, 2008 at 12:18 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> H. Peter Anvin wrote:
>>
>> The most likely explanation for this is that the VESA BIOS expects to be
>> entered in Big Real Mode (*.limit = 0xffffffff) instead of ordinary Real
>> Mode.  Here is a completely untested patch which changes the segment
>> descriptors to Big Real Mode instead.  It would be worth testing out.
>>
>
> ... and here is one that actually has a prayer of actually working.
>
>        -hpa
>
>
> --- AV & Spam Filtering by M+Guardian - Risk Free Email (TM) ---
>
