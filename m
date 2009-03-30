Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbZC3TIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbZC3TIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 15:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759136AbZC3TIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 15:08:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:12903 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346AbZC3TIJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 15:08:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mEJlTrRh1XeDki29shkqn23PbepNS0AMUjMhmWWJhaAVL+6nfNJhsOoT3puI9Dhc0j
         fWKQmtZt0nKbJCTjyTfDR+26Es8seJRbJQTXdTtSs3QWmqbr87Uj6aFBi9E4bOEdHbyZ
         s3taQi6xXHm/o4TXnB2zuo0HTKvWdfHGpZxKA=
MIME-Version: 1.0
In-Reply-To: <ac3eb2510903301142h21dec2eajd03057095aa4f11c@mail.gmail.com>
References: <49CF9BA1.5030400@archlinux.org>
	 <20090329091148.16a618bf@infradead.org>
	 <49CFA436.5080000@archlinux.org>
	 <ac3eb2510903291036w13dc34cbi97525e6dd9af1da5@mail.gmail.com>
	 <49CFB553.1020800@archlinux.org>
	 <ac3eb2510903291106k27902bafpa8231d6781f8f5c@mail.gmail.com>
	 <e9c3a7c20903301123l3f05264cvb8522dd4cb030b2f@mail.gmail.com>
	 <ac3eb2510903301142h21dec2eajd03057095aa4f11c@mail.gmail.com>
Date: Mon, 30 Mar 2009 12:08:07 -0700
X-Google-Sender-Auth: 0422d50bcab69e7e
Message-ID: <e9c3a7c20903301208k6fe17c92xe855a3c85d893454@mail.gmail.com>
Subject: Re: fastboot/async and initramfs: How am I supposed to know when 
	devices are finished initializing?
From: Dan Williams <dan.j.williams@intel.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: =?ISO-8859-1?Q?Thomas_B=E4chler?= <thomas@archlinux.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 11:42 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Mon, Mar 30, 2009 at 20:23, Dan Williams <dan.j.williams@intel.com> wrote:
>
>> settle: allow --timeout=0 to test for "queue busy"
>
>> +       if (!udev_queue_get_queue_is_empty(udev_queue))
>> +               rc = 1;
>
> You mean, we should not wait? Then we need to check for timeout == 0
> and return immediately instead of entering the checking loop at all,
> right?
>

We already skip if loop==0...?

</me checks latest git>

Oh, this patch (against 138) needs to be reworked.

Thanks,
Dan
