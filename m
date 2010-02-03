Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab0BCR2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:28:41 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:43388 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688Ab0BCR2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:28:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=HhA5Q6duElOZB8UKccGJfbb6hJJcjQoGEqdmzm6SY/G54HBwwKifcHIXax4tnDV5Tt
         kanMKGpAM8SO/Ff6+vO5S3MjHjfKIf5eqnf3acKskAErrbBKdLx2DJDa03uik+cNJGPI
         pEldwi8wotYFHM7Ogi809vsh8ifzD8+YgxJgQ=
Date: Wed, 3 Feb 2010 15:28:31 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Mike Galbraith <efault@gmx.de>
Cc: john smith <whalajam@yahoo.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: perf report for .ko files
Message-ID: <20100203172831.GC8548@ghostprotocols.net>
References: <20100126210552.GA12567@ghostprotocols.net>
 <229562.61603.qm@web55007.mail.re4.yahoo.com>
 <20100129191558.GA9990@ghostprotocols.net>
 <1264833954.6097.13.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264833954.6097.13.camel@marge.simson.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Jan 30, 2010 at 07:45:54AM +0100, Mike Galbraith escreveu:
> On Fri, 2010-01-29 at 17:15 -0200, Arnaldo Carvalho de Melo wrote:
> 
> > I actually never tried doing annotation with a module, will try.
> 
> Seems it went south again in both .git and .tip.  32 works.

We need to read the ELF header, notice its a relocatable file and not
apply the unmap_ip functions, doing a patch now.

- Arnaldo
