Return-Path: <linux-kernel-owner+w=401wt.eu-S1753067AbZA1Oxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbZA1Oxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 09:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbZA1OxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 09:53:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:43505 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZA1OxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 09:53:21 -0500
Date: Wed, 28 Jan 2009 06:52:31 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: Re: [PATCH 5/6] module: make modversion_info contain a pointer, not
 an array.
Message-ID: <20090128065231.64d12ffd@infradead.org>
In-Reply-To: <200901290005.52819.rusty@rustcorp.com.au>
References: <200901290005.52819.rusty@rustcorp.com.au>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009 00:05:52 +1030
Rusty Russell <rusty@rustcorp.com.au> wrote:

> 
> With allmodconfig (minus non-building modules) on 32-bit x86:
> Total size of modules before: 60009790 bytes
> Total size of modules after: 55927866 bytes
> 
> Saving 7% of module size for CONFIG_MODVERSIONS=y; and these sections
> are kept resident as well.
> 

that reminds me.. can we just simplify MODVERSIONS to be a md5sum (or
sha1 whatver) of the .config file in the VERMAGIC ?
it's a lot more reliable in detecting incompatibilities, and a lot
less space consumed.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
