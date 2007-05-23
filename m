Return-Path: <linux-kernel-owner+w=401wt.eu-S1761647AbXEWXLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761647AbXEWXLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 19:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755952AbXEWXLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 19:11:37 -0400
Received: from outbound-mail-76.bluehost.com ([69.89.22.25]:38356 "HELO
	outbound-mail-76.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755287AbXEWXLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 19:11:37 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: David Miller <davem@davemloft.net>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Wed, 23 May 2007 16:11:17 -0700
User-Agent: KMail/1.9.6
Cc: torvalds@linux-foundation.org, hancockr@shaw.ca, galibert@pobox.com,
       linux-kernel@vger.kernel.org, ak@suse.de, cebbert@redhat.com,
       lenb@kernel.org
References: <alpine.LFD.0.98.0705231444200.3890@woody.linux-foundation.org> <alpine.LFD.0.98.0705231514410.3890@woody.linux-foundation.org> <20070523.160415.26274543.davem@davemloft.net>
In-Reply-To: <20070523.160415.26274543.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705231611.18944.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 23, 2007 4:04 pm David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Wed, 23 May 2007 15:16:23 -0700 (PDT)
>
> > That crap should be seen for the crap it is! Dammit, how hard can
> > it be to just admit that mmconfig isn't that great?
>
> I knew mmconfig was broken conceptually the first time I started
> seeing write posting "bug fixes" for it that would do a read back
> from PCI config space via mmconfig to post the write, which of course
> has potential side-effects on the device and is absolutely illegal if
> the write just performed put the device into a PM state or whatever.

I've actually seen that specific form of posted write flushing cause 
crashes on some machines, so yes, it sucks.

Unfortunately, I don't think we have any other way of getting at 
extended config space on x86, unless EFI provides methods or something, 
but I'm not sure that would be an improvement...

Jesse
