Return-Path: <linux-kernel-owner+w=401wt.eu-S1760972AbYG3Jlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbYG3Jlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYG3Jla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:41:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751812AbYG3Jl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:41:29 -0400
Date: Wed, 30 Jul 2008 02:40:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Q: support for AVM Fritz! WLAN USB in kernel 2.6.25+
Message-Id: <20080730024054.aa41729a.akpm@linux-foundation.org>
In-Reply-To: <488EDC63.8060700@imap.cc>
References: <488EDC63.8060700@imap.cc>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 11:01:23 +0200 Tilman Schmidt <tilman@imap.cc> wrote:

> Commit 782e70c6fc2290a0395850e8e02583b8b62264d8, which went into
> 2.6.25, broke AVM's closed-source driver for this device:

  commit 782e70c6fc2290a0395850e8e02583b8b62264d8
  Author: Greg Kroah-Hartman <gregkh@suse.de>
  Date:   Fri Jan 25 11:12:21 2008 -0600

      USB: mark USB drivers as being GPL only

It would.

> ID 057c:62ff AVM GmbH WLAN USB v1.1 (cdrom mode)
> ID 057c:6201 AVM GmbH WLAN USB v1.1
> 
> Is there an open source alternative for that driver,

There doesn't seem to be one in-tree.  But linux-usb and/or linux-wireless
might be better places to ask.

> or do systems
> with that device have to stay with kernel 2.6.24?

It seems that way.
