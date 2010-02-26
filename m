Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965694Ab0BZSYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 13:24:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965631Ab0BZSYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 13:24:30 -0500
Date: Fri, 26 Feb 2010 19:23:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] umh && creds: convert
	call_usermodehelper_keys() to use subprocess_info->init()
Message-ID: <20100226182325.GA31674@redhat.com>
References: <20100225181500.GA18008@redhat.com> <16951.1267207238@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16951.1267207238@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > +	/*
> > +	 * This is called in context of freshly forked kthread before
> > +	 * kernel_execve(), we can just change our ->session_keyring.
> > +	 */
>
> Ummmm....  What gives you that idea?
>
> You may be sharing init_cred...

How? Without CLONE_THREAD copy_creds() always creates the new
struct cred for the child?

Oleg.

