Return-Path: <linux-kernel-owner+w=401wt.eu-S1760631AbYGOAbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760631AbYGOAbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 20:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757227AbYGOAb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 20:31:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:14542 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbYGOAb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 20:31:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oLLUBL5f7TTNIYwRj06b7jm5cl3A7hGqgGb7Zi+H5sm1LU3fJW66mgUkSghlPGjiIZ
         7ZYrKhPk34a9JFPmo8XeDLigH12p50LsZpX3fqY2+bzJFd5rS2CPk7/nlOSQFC8xNtOj
         ibqzblnmfdVV1nKwlPkLeRp/WSAUdV8rcYueU=
Message-ID: <86802c440807141731m5286f640jfeaff1a73b923e7@mail.gmail.com>
Date: Mon, 14 Jul 2008 17:31:26 -0700
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
>

CONFIG_EXTRA_FIRMWARE="ql2100_fw.bin  ql2300_fw.bin  ql2400_fw.bin
ql2200_fw.bin  ql2322_fw.bin  ql2500_fw.bin"
CONFIG_EXTRA_FIRMWARE_DIR="firmware"


make[1]: *** No rule to make target
`include/config/builtin/firmware/dir.h', needed by
`firmware/ql2100_fw.bin.gen.S'.  Stop.
make: *** [firmware] Error 2

YH
