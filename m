Return-Path: <linux-kernel-owner+w=401wt.eu-S1763439AbXK2Qwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763439AbXK2Qwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762832AbXK2QwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:52:21 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:48160 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762794AbXK2QwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:52:20 -0500
Date: Thu, 29 Nov 2007 17:52:19 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jon Masters <jcm@redhat.com>
cc: James Morris <jmorris@namei.org>, tvrtko.ursulin@sophos.com,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: Out of tree module using LSM
In-Reply-To: <1196353666.6473.43.camel@perihelion>
Message-ID: <Pine.LNX.4.64.0711291748140.13075@fbirervta.pbzchgretzou.qr>
References: <OF74C1FF25.986585E9-ON802573A1.006239BF-802573A1.0064DE96@sophos.com>
  <Xine.LNX.4.64.0711291000590.21270@us.intercode.com.au>
 <1196353666.6473.43.camel@perihelion>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 29 2007 11:27, Jon Masters wrote:
>
>They (virus protection folks) generally think they want to intercept
>various system calls, such as open() and block until they have performed
>a scan operation on the file. I explained the mmap issue [...]

If open and close was everything, then that would be wonderful. You
could only wonder how many false positives scanners could bring up if
they checked every write() for signatures - not to mention
performance bogdown.

>they just want to scan files and take some action if a file is
>"bad". That's it really.
>
struct security->dentry_open sounds like the candidate, together
with relayfs with submits filenames to userspace.

