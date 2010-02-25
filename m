Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333Ab0BYSxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 13:53:31 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:34098 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab0BYSxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 13:53:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H8jYrT6BYtqX3Yl1W1X4F6pyfJcK8aMf70IZMeHsvpCpxPEv0IjNRF7Mhzb5KWvIhU
         31LjCvKvzo925heBxpVLUkXyL0NF8uAOyg1Zl6ECsv0tIMFRYvmzSRZGCSjvVCF9erL6
         xX/wCyrEUm3UZyxPNm6BZXT4hFJo6m7NxzXXk=
Date: Thu, 25 Feb 2010 20:53:20 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/07] kernel.h panic cleanup
Message-ID: <20100225185320.GA3305@core2>
References: <20100225153911.GA2661@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100225153911.GA2661@darkstar>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 11:39:11PM +0800, Dave Young wrote:
> Cleanup kernel.h panic related stuff, move to linux/panic.h 
> 
> Due to lots of files need it, include them in kernel.h just for convinience
> It can be thought as the first step of further cleanup. 

NAK, tainted stuff belongs to separate place.

> --- linux-2.6.orig/include/linux/kernel.h
> +++ linux-2.6/include/linux/kernel.h
> -extern const char *print_tainted(void);
> -extern void add_taint(unsigned flag);
> -extern int test_taint(unsigned flag);
> -extern unsigned long get_taint(void);
