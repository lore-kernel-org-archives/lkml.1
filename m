Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbZLNWDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbZLNWDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758561AbZLNWDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:03:13 -0500
Received: from smtp.nokia.com ([192.100.122.230]:36540 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537AbZLNWDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:03:09 -0500
Date: Tue, 15 Dec 2009 00:02:20 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: "ext Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "krzysztof.h1@wp.pl" <krzysztof.h1@wp.pl>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "oliver@neukum.org" <oliver@neukum.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "jkosina@suse.cz" <jkosina@suse.cz>
Subject: Re: [PATCH] Logitech G13 driver (fixed cc list --- ignore others)
Message-ID: <20091214220220.GB2052@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <200912142122.nBELMW7d001243@mustang.cs.nmsu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <200912142122.nBELMW7d001243@mustang.cs.nmsu.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 14 Dec 2009 22:02:45.0617 (UTC) FILETIME=[2A969610:01CA7D09]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 14, 2009 at 10:22:32PM +0100, ext Rick L. Vinyard Jr. wrote:
>
>Signed-off-by: Rick L. Vinyard, Jr <rvinyard@cs.nmsu.edu>

there are plenty of style mistakes in this patch. the body message 
description which you put below should be above the signed-off-by line,
multi-lined comments are of the form:

/*
  * multi lined comment
  * goes here
  */

remove the commented code like /* hid_debug = 0 */

and some others.. please run your patch through scripts/checkpatch.pl 
--strict and fix the errors and warnings reported.

please take a look at Documentation/SubmittingPatches and 
Documentation/CodingStyle for further reference.

When sending the patch, you could also use git send-email to avoid the 
problem you had with 'mail'.

>+static int __init g13_init(void)
>+{
>+       pr_debug("g13 HID driver loaded");

don't pr_debug() here.

>+       return hid_register_driver(&g13_driver);
>+}
>+
>+static void __exit g13_exit(void)
>+{
>+       pr_debug("g13 HID driver unloaded");

nor here.

>+       hid_unregister_driver(&g13_driver);
>+}

-- 
balbi
