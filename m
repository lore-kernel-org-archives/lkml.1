Return-Path: <linux-kernel-owner+w=401wt.eu-S1751489AbYDPSav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489AbYDPSav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbYDPS3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:29:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbYDPS3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:29:44 -0400
Date: Wed, 16 Apr 2008 11:29:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vitaliy Ivanov" <vitalivanov@gmail.com>
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org, marcel@holtmann.org,
       maxk@qualcomm.com, linux-bluetooth@vger.kernel.org
Subject: Re: hci_usb: remove macro code obfuscation
Message-Id: <20080416112909.505fe619.akpm@linux-foundation.org>
In-Reply-To: <35fbaa3e0804160351g1795b47bh6dbb2c8d596d0129@mail.gmail.com>
References: <20080416104257.GA1621@elf.ucw.cz>
	<35fbaa3e0804160351g1795b47bh6dbb2c8d596d0129@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008 13:51:37 +0300
"Vitaliy Ivanov" <vitalivanov@gmail.com> wrote:

> On Wed, Apr 16, 2008 at 1:42 PM, Pavel Machek <pavel@ucw.cz> wrote:
> >
> >  I had trouble figuring out what the code does. atomic_inc/dec
> >  management is actually pretty simple, but it is needlessly obfuscated
> >  with macros. Fix that.
> >
> >  Signed-off-by: Pavel Machek <pavel@suse.cz>
> >
> >  I had trouble figuring out what the code does. atomic_inc/dec
> >  management is actually pretty simple, but it is needlessly obfuscated
> >  with macros. Fix that.
> >
> >  Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> 
> Got it from the first time;)
> 
> Do you think that now code looks better? As for me it's not...
> 

Yes, I expect that the original code was easier to work with and it is not
obfuscated I don't think.  Sometimes these things take a few minutes for
new readers to become comfortable with but are good for people who work on
the code regularly.

Although it's a mystery why __pending_tx() and friends

a) have leading underscores and

b) are implemented in cpp, when C is available.
