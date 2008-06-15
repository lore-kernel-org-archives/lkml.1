Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbYFOGuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbYFOGuu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 02:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYFOGug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 02:50:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:31327 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbYFOGuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 02:50:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IE+PWrN5Yddn5VMw3zWyxY1wUzREFjKnxGu6+fKg9ZBqHMcwKv1QWqmSreYIPYZ1qT
         V3eHlWwYQiozMHcedf+IBVfrMJD/1OQol5YaAvMp1R2YgpylWxvxCdftjyNS9kr0vpN2
         MsomgG4HtJcGtYXuJuPoWvJBKsJE2gYQ0gx/g=
Subject: Re: [PATCH 2/2] 8139too: different style cleanups
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Newall <davidn@davidnewall.com>
Cc: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
       Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       Trivial Patch Monkey <trivial@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4854B604.6080900@davidnewall.com>
References: <4853BB7B.4030905@freemail.hu> <48541173.7040905@freemail.hu>
	 <4854B604.6080900@davidnewall.com>
Content-Type: text/plain; charset=utf-8
Date: Sat, 14 Jun 2008 23:50:37 -0700
Message-Id: <1213512637.11544.36.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-15 at 15:56 +0930, David Newall wrote:
> Németh Márton wrote:
> >  #  define DPRINTK(fmt, args...) \
> > -	printk(KERN_DEBUG "%s: " fmt, __FUNCTION__ , ## args)
> > +	printk(KERN_DEBUG "%s: " fmt, __func__ , ## args)
> >   
> 
> Why change __FUNCTION__ to __func__?  I don't even know where __func__
> come from?  Assuming that it isn't totally broken, and I'll believe that
> it isn't, then would it be compiler-specific?   __FUNCTION__ is standard
> and that's more than enough reason to prefer that form to any
> non-standard variation.

__FUNCTION__ is gcc-specific, __func__ is C99.

Harvey

