Return-Path: <linux-kernel-owner+w=401wt.eu-S1758705AbYGOAuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbYGOAuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 20:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756078AbYGOAua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 20:50:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:25487 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871AbYGOAua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 20:50:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=whYfcIvUiJyVxleXftwlXYE/3frrBrkby81QqfxVH8f0dn7kV0w0X4G73BzBJTqpAW
         oXyZe1VaQxXw3H4bjDYLpkQbG4JBGUS8zB/ohfOtQWgyCiKMJT20It63bk2HH51q7ifB
         p8gpda5T34AdGpaTHx3Ey+CXYautZBLku7hoY=
Message-ID: <86802c440807141750m937c824kf37c5adf490c8e4a@mail.gmail.com>
Date: Mon, 14 Jul 2008 17:50:28 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Cc: "Andrew Morton" <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <1216081404.27455.97.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <1216079223.27455.92.camel@shinybook.infradead.org>
	 <86802c440807141653s22b91c72gadd6f51ea4a477a@mail.gmail.com>
	 <1216081404.27455.97.camel@shinybook.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 5:23 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Mon, 2008-07-14 at 16:53 -0700, Yinghai Lu wrote:
>> so after this patchset, if i put qllogic fw in firmware/, that fw will
>> work or not...
>
> The qlogic driver already uses request_firmware(), like most modern
> drivers do. If you want to include that firmware in your kernel image
> (assuming it's in /lib/firmware already), do something like this:
>
>        CONFIG_EXTRA_FIRMWARE="ql2500_fw.bin"
>        CONFIG_EXTRA_FIRMWARE_DIR=/lib/firmware
>
> Then it'll find that firmware file and pull it in to your kernel, and
> you can set CONFIG_SCSI_QLA_FC=y and expect it to work. Select the right
> firmware for your device, of course.

  MK_FW   firmware/tigon/tg3.bin.gen.S
make[1]: *** No rule to make target `firmware/tigon/tg3.bin', needed
by `firmware/tigon/tg3.bin.gen.o'.  Stop.
make: *** [firmware] Error 2

YH
