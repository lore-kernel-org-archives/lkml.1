Return-Path: <linux-kernel-owner+w=401wt.eu-S1759960AbXHEN0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbXHEN0Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 09:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbXHEN0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 09:26:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:44003 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbXHEN0R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 09:26:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aOTdHP2hA8Maw15ESL72weqE/05Hduvo6chIG2zc/uxKw/k/ewS4HAxyOa5D1PMQgRhvzUuKGzKzyLDBrKIc/6mjAfRsSgoxHDbAJhWdic+W4Ooyi1bmJvq2n/DNCRFrosRW6uTzPbUerYOY8ITRTgGLKa3rvks/mtgq9rduals=
Message-ID: <b6a2187b0708050626s15e1b7did73f638046c0dba3@mail.gmail.com>
Date: Sun, 5 Aug 2007 21:26:17 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: Linux 2.6.23-rc2
Cc: "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <1186317610.5220.3.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <Pine.LNX.4.64.0708052005550.3772@boston.corp.fedex.com>
	 <1186317610.5220.3.camel@daplas>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/5/07, Antonino A. Daplas <adaplas@gmail.com> wrote:

> Can you try with the boot option acpi_sleep=s3_bios,s3_mode
> OR
> if using s2ram, use s2ram -f a3

Tried both, text-console still not restored.

In fact, with "s2ram -f a3", backlight doesn't get restored. I've to
switch to F1 and back to X to get backlight to come back on.

One way to get console back is to "suspend-to-disk", and upon resume,
text-console works just fine.

Here's what see when I "cat /dev/vcs1" ...

            ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ

The pattern repeats and fill the whole screen.

Thanks,
Jeff.
