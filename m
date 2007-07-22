Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbXGVFBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbXGVFBX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 01:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbXGVFBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 01:01:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:53622 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbXGVFBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 01:01:16 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Dave Jones <davej@redhat.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix empty macros in acpi.
Date: Sun, 22 Jul 2007 00:55:16 -0400
User-Agent: KMail/1.9.5
References: <20070612233309.GA24251@redhat.com> <200707030122.47747.lenb@kernel.org> <20070703054455.GB32110@redhat.com>
In-Reply-To: <20070703054455.GB32110@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707220055.16577.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 July 2007 01:44, Dave Jones wrote:
> On Tue, Jul 03, 2007 at 01:22:47AM -0400, Len Brown wrote:
> 
>  > whelp, it seems that the reason for this patch is this:
>  > 
>  > #define DBG()
>  > 
>  > if(...)
>  > 	DBG();
>  > next_c_statement
>  > 
>  > which turns into
>  > if(...) ;
>  > next_c_statement
>  > 
>  > But since there is an intervening ';', this code is still functionally correct
>  > and a decent compiler will delete the test altogether, yes?
> 
> Right, gcc does generate the correct code.
> 
>  > So is there some real problem here that I missed,
>  > or is this to make some code-checking tool that I don't have happy?
> 
> Out of curiousity, I thought I'd see what was lurking in a -Wextra
> build a while back. It's 99.9% noise, but a lot of it is trivial stuff
> like this.

okay, i'll apply it to reduce the noise.

thanks,
-Len
