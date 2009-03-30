Return-Path: <linux-kernel-owner+w=401wt.eu-S1758397AbZC3Sn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbZC3Sn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758420AbZC3Smz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:42:55 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:60560 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758505AbZC3Smy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:42:54 -0400
MIME-Version: 1.0
In-Reply-To: <e9c3a7c20903301123l3f05264cvb8522dd4cb030b2f@mail.gmail.com>
References: <49CF9BA1.5030400@archlinux.org> <20090329091148.16a618bf@infradead.org> 
	<49CFA436.5080000@archlinux.org> <ac3eb2510903291036w13dc34cbi97525e6dd9af1da5@mail.gmail.com> 
	<49CFB553.1020800@archlinux.org> <ac3eb2510903291106k27902bafpa8231d6781f8f5c@mail.gmail.com> 
	<e9c3a7c20903301123l3f05264cvb8522dd4cb030b2f@mail.gmail.com>
Date: Mon, 30 Mar 2009 20:42:36 +0200
Message-ID: <ac3eb2510903301142h21dec2eajd03057095aa4f11c@mail.gmail.com>
Subject: Re: fastboot/async and initramfs: How am I supposed to know when 
	devices are finished initializing?
From: Kay Sievers <kay.sievers@vrfy.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: =?UTF-8?Q?Thomas_B=C3=A4chler?= <thomas@archlinux.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 20:23, Dan Williams <dan.j.williams@intel.com> wrote:

> settle: allow --timeout=0 to test for "queue busy"

> +       if (!udev_queue_get_queue_is_empty(udev_queue))
> +               rc = 1;

You mean, we should not wait? Then we need to check for timeout == 0
and return immediately instead of entering the checking loop at all,
right?

Thanks,
Kay
