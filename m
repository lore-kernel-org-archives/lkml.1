Return-Path: <linux-kernel-owner+w=401wt.eu-S1751415AbXBNIsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbXBNIsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 03:48:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbXBNIsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 03:48:04 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47896 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbXBNIsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 03:48:02 -0500
Date: Wed, 14 Feb 2007 00:47:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vitaly Wool" <vitalywool@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8250: make probing for TXEN bug a config option
Message-Id: <20070214004755.faa96e55.akpm@linux-foundation.org>
In-Reply-To: <acd2a5930702140037yff0b77dl2714ea7869bdde54@mail.gmail.com>
References: <20061226194317.3fd3ec14.vitalywool@gmail.com>
	<20070213224643.14d27cd3.akpm@linux-foundation.org>
	<acd2a5930702140037yff0b77dl2714ea7869bdde54@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007 11:37:52 +0300 "Vitaly Wool" <vitalywool@gmail.com> wrote:

> On 2/14/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > I think this should be a module option/boot parameter, not a config-time
> > option.
> >
> >
> Hmm, why? I can't think of a platform where one 8250-compatible UART is
> problematic and another isn't :)
> 

Is it not possible that the same kernel package can be installed on systems
which do and don't need this feature?  If so, we don't want to force the
provider of that package to create two packages.

That, plus the chances of the package creator actually knowing about this
option aren't great.

Generally, if it can be done at runtime it is better to do so, no?
