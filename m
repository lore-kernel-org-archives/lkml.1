Return-Path: <linux-kernel-owner+w=401wt.eu-S1757799AbXK3WaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799AbXK3WaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 17:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbXK3W3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 17:29:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:42005 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbXK3W3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 17:29:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=LgFl4TXmoBVuyr9ZiWt36jzMz9UwlCRyd8bxPwomnGSP/dPTJCST6WZLJ3r4iFeEU/OjNYC4Ou7PuT+rOYGP8G84T2pqS3Pmf5Tab/h6Jzlfx5IG5c2DD4nxs5IUpGZFO9oqf6opORJBU3n7YjKyONq7Mt9Has+72Ir8w0+WLSw=
Message-ID: <47508EDB.7080205@gmail.com>
Date: Fri, 30 Nov 2007 23:29:47 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Andrew Morton <akpm@osdl.org>, "Serge E. Hallyn" <serue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: capabilities-introduce-per-process-capability-bounding-set.patch
 breaks FC6 Avahi
References: <20071130194134.GA7536@c2.user-mode-linux.org>
In-Reply-To: <20071130194134.GA7536@c2.user-mode-linux.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2007 08:41 PM, Jeff Dike wrote:
> avahi-daemon fails to start on FC6 when
> capabilities-introduce-per-process-capability-bounding-set.patch is
> applied.
> 
> strace shows
> 	capset(0x19980330, 0, {CAP_SETGID|CAP_SETUID|CAP_SYS_CHROOT, CAP_SETGID|CAP_SETUID|CAP_SYS_CHROOT, 0}) = -1 EPERM (Operation not permitted)
> 
> I don't know if this is expected, but the changelog doesn't seem to
> imply that this will break things.

Nope, try this :):
http://lkml.org/lkml/2007/11/28/390

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
