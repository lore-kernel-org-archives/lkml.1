Return-Path: <linux-kernel-owner+w=401wt.eu-S964893AbXCUU63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964893AbXCUU63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 16:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964931AbXCUU63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 16:58:29 -0400
Received: from smtp.bulldogdsl.com ([212.158.248.8]:2302 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964893AbXCUU63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 16:58:29 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: rol@as2917.net
Subject: Re: Why is /dev on a different filesystem ? [Kernel 2.6.20.3]
Date: Wed, 21 Mar 2007 20:58:18 +0000
User-Agent: KMail/1.9.5
Cc: "'LKML'" <linux-kernel@vger.kernel.org>
References: <04ea01c76bed$11b0d050$4b00a8c0@donald>
In-Reply-To: <04ea01c76bed$11b0d050$4b00a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703212058.18067.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 March 2007 19:13, Paul Rolland wrote:
> So, obviously, /dev is on /, but the stat(2) says no.
> Who is right, and where is the bug ?
>
> Kernel 2.4 had it right : /dev was on /, no doubt.

Some distros will mount tmpfs over /dev so that a minimal "real dev" can be 
provided as a fallback, but udev can add and remove nodes from /dev ad hoc 
during regular runtime. So I don't think there's a bug and I don't think 
anything is lying.

If you want the dev your distro gave you, just mount your rootfs on another 
mount point in read-only and run tar over that instead.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
