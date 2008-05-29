Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbYE2RTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbYE2RTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 13:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbYE2RTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 13:19:32 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48693 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbYE2RTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 13:19:32 -0400
Date: Thu, 29 May 2008 19:20:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Steve French <smfrench@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: optimizing out inline functions
Message-ID: <20080529172012.GA15469@uranus.ravnborg.org>
References: <524f69650805281251r1b1d99a1tc3223d15e3aeb50c@mail.gmail.com> <20080528200057.GA7300@uranus.ravnborg.org> <524f69650805290939v65f9f5b8m65fd1ba23acd08d8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524f69650805290939v65f9f5b8m65fd1ba23acd08d8@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 11:39:32AM -0500, Steve French wrote:
> Ran into one loosely related question, printk takes a variable
> argument list, so the calling function in this case would also need to
> be able to handle thos variable arguments.  With macros, we are able
> to do things like with variable arguments easily
> 
> #define function_to_print_some_warning(format, arg...)
> printk(KERN_WARNING ": " format "\n" , ## arg)
> 
> Are there style rules (or nicely written examples) for doing this
> (variable argument lists) with (inline) functions

Searching the code base I'm sure you will find plenty.
But I cannot point one out from the top of my head.

	Sam
