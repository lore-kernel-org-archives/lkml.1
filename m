Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbZF2Dr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbZF2Dr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 23:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZF2DrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 23:47:20 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:51340 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZF2DrT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 23:47:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mbtKI5iVu4ANRK4lCSdSR32Q+tSkOF2uUIeaeJQ/3iwoMfaZB8D8KQAKaGdA8TGo/H
         1iCQhzqHXV+inEGc5gZmNJT5rUvCG8ur5ig1FmVUuH9Wq0Wh1Jkt9PVMmh5wjj0MtMrC
         p1uSZyh8hIi7O4bX3X6bWzFj1S12yz35tGQxM=
MIME-Version: 1.0
In-Reply-To: <20090629015738.GQ20436@tamriel.snowman.net>
References: <20090628034038.GK20436@tamriel.snowman.net>
	 <86802c440906272126s7d3b97afh16069280bd297827@mail.gmail.com>
	 <20090628223132.GO20436@tamriel.snowman.net>
	 <86802c440906281849m51ab3c82u84d76a1aaceba2ef@mail.gmail.com>
	 <20090629015738.GQ20436@tamriel.snowman.net>
Date: Sun, 28 Jun 2009 20:47:22 -0700
Message-ID: <86802c440906282047h23d45627pacec7a23f871fc2c@mail.gmail.com>
Subject: Re: ACPI issues on HP DL585 G2
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Stephen Frost <sfrost@snowman.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 6:57 PM, Stephen Frost<sfrost@snowman.net> wrote:
> * Yinghai Lu (yhlu.kernel@gmail.com) wrote:
>> are you sure these two come from same BIOS ?
>
> They might not..  I did upgrade the BIOS to the latest revision and I
> don't recall if the last 2.6.22 boot was before or after the BIOS
> upgrade.  The 2.6.29 and 2.6.30 boots (both w/o APIC) are from the same
> BIOS.  Would it help to try booting under 2.6.22 with the BIOS that's on
> there now?

that would help

>
> Is there some other information I could provide while the machine is
> running?  Unfortunately, this is a rather important box for us.

put debug in /boot/grub/grub.conf for the kernel
and boot with serial console enabled...
to capture all.

YH
