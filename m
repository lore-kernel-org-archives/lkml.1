Return-Path: <linux-kernel-owner+w=401wt.eu-S1758463AbYHEFV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463AbYHEFV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 01:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbYHEFVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 01:21:49 -0400
Received: from po-out-1718.google.com ([72.14.252.159]:41642 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbYHEFVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 01:21:47 -0400
Message-ID: <f73f7ab80808042221v5bebcea9o7e536093373647cd@mail.gmail.com>
Date: Tue, 5 Aug 2008 01:21:46 -0400
From: "Kyle Moffett" <kyle@moffetthome.net>
To: "Russ Anderson" <rja@sgi.com>
Subject: Re: x86 BIOS interface for partitioning and system serial number on SGI UV
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, "Jack Steiner" <steiner@sgi.com>
In-Reply-To: <20080804221951.GA252105@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080731195753.GB25715@sgi.com> <48934926.2010200@zytor.com>
	 <20080804221951.GA252105@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2008 at 6:19 PM, Russ Anderson <rja@sgi.com> wrote:
> On Fri, Aug 01, 2008 at 10:34:30AM -0700, H. Peter Anvin wrote:
>>Russ Anderson wrote:
>>>+# define BIOS_CALL(result, a0, a1, a2, a3, a4, a5, a6, a7)          \
>>>+    do {                                                            \
>>>+            /* XXX - the real call goes here */                     \
>>>+            result.status = BIOS_STATUS_UNIMPLEMENTED;              \
>>>+            result.v0 = 0;                                          \
>>>+            result.v1 = 0;                                          \
>>>+    } while (0)
>>
>> I have more than a little problem with submitting patches like this.  We
>> have no way to judge the suitability of the coding or the interface with
>> the "meat" of the driver stubbed out!
>
> This is also code for hardware that does not exist.  In order for the
> code to be in distro releases in time for the hardware to ship, we
> must push it _before_ we have hardware.  The main concern is getting in
> interfaces now, because the interfaces cannot change in a minor release.
> Providing more "meat" is on the ToDo list.

These kinds of statements are not the way to get things done on LKML.
Quite a number of people have gotten flamed/ignored/etc lately by
making statements "We need this (unfinished code) in the kernel by
2.6.27 because RHEL6 is going to use 2.6.27 and otherwise we won't be
supported in RHEL6".

Cheers,
Kyle Moffett
