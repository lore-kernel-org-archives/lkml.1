Return-Path: <linux-kernel-owner+w=401wt.eu-S1423341AbXBHWzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423341AbXBHWzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 17:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423323AbXBHWzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 17:55:06 -0500
Received: from raven.upol.cz ([158.194.120.4]:38491 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423341AbXBHWzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 17:55:05 -0500
Date: Fri, 9 Feb 2007 00:03:28 +0100
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Kbuild refactoring (Re: The who needs reviews anyways [PATCH])
Message-ID: <20070208230328.GB28386@flower.upol.cz>
References: <Pine.LNX.4.64.0702082227020.14457@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702082227020.14457@scrub.home>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 10:48:51PM +0100, Roman Zippel wrote:
[]
> - printf has other side effects, instead stop pretending we support 
>   something else than bash

Yes. With `%' in option strings there will be side effects.
I would suggest to use

    printf %s "$(1)"

with "paranoia mode on", and hope to do not forcing `bash'.

> - proper quoting
> - proper indentation
> 
> bye, Roman

Thanks.

____
