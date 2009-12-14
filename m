Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbZLNWtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbZLNWtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758656AbZLNWtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:49:49 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:37034 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758591AbZLNWts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:49:48 -0500
Message-ID: <db910869762a655c288c762e82e83d3e.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <20091214220220.GB2052@nokia.com>
References: <200912142122.nBELMW7d001243@mustang.cs.nmsu.edu>
    <20091214220220.GB2052@nokia.com>
Date: Mon, 14 Dec 2009 15:48:43 -0700
Subject: Re: [PATCH] Logitech G13 driver (fixed cc list --- ignore others)
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: felipe.balbi@nokia.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "krzysztof.h1@wp.pl" <krzysztof.h1@wp.pl>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "oliver@neukum.org" <oliver@neukum.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "jkosina@suse.cz" <jkosina@suse.cz>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Felipe Balbi wrote:
> On Mon, Dec 14, 2009 at 10:22:32PM +0100, ext Rick L. Vinyard Jr. wrote:
>>
>>Signed-off-by: Rick L. Vinyard, Jr <rvinyard@cs.nmsu.edu>
>
> there are plenty of style mistakes in this patch. the body message
> description which you put below should be above the signed-off-by line,

Fixed in the new patch labelled 0.0.2

> multi-lined comments are of the form:
>
> /*
>   * multi lined comment
>   * goes here
>   */
>

Fixed

> remove the commented code like /* hid_debug = 0 */
>

Removed

> and some others.. please run your patch through scripts/checkpatch.pl
> --strict and fix the errors and warnings reported.
>

I ran it without the --strict option before. That's probably why I didn't
catch it. It's clean now with --strict.

>>+static int __init g13_init(void)
>>+{
>>+       pr_debug("g13 HID driver loaded");
>
> don't pr_debug() here.
>

Removed

>>+       return hid_register_driver(&g13_driver);
>>+}
>>+
>>+static void __exit g13_exit(void)
>>+{
>>+       pr_debug("g13 HID driver unloaded");
>
> nor here.
>
>>+       hid_unregister_driver(&g13_driver);
>>+}

Removed

Thanks for the input. Everything above is taken into account in v0.0.2 of
the patch.

---

Rick

