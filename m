Return-Path: <linux-kernel-owner+w=401wt.eu-S1759011AbXK1AKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011AbXK1AKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 19:10:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760296AbXK1AJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 19:09:50 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:37995 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760185AbXK1AJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 19:09:49 -0500
Date: Tue, 27 Nov 2007 19:09:21 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       miklos@szeredi.hu
Subject: Re: [PATCH] UML - Fix !NO_HZ busy-loop
Message-ID: <20071128000921.GA11012@c2.user-mode-linux.org>
References: <20071127200347.GA8847@c2.user-mode-linux.org> <20071127150108.fb94aaca.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127150108.fb94aaca.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 03:01:08PM -0800, Andrew Morton wrote:
> > +#ifdef UML_CONFIG_NO_HZ
> 
> Nothing ever defines this?

$ grep HZ obj/arch/um/include/uml-config.h 
#define UML_CONFIG_NO_HZ 1

uml-config.h is auto-generated to provide the config definitions to the
userspace side of UML.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
