Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbYACMQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbYACMQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 07:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbYACMQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 07:16:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:50149 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbYACMQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 07:16:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=ja2QuUEP0pW+uYgECRLnTeUKEdfodDy54aehw89KnbwU6+B3+yFUeCJx/Kpc6xSHNDfVN/n298F1LzgFCiDq8hYEFdFWESDlrzS4pTWT+s0C1I7IxVMJP17D9dVwSrSbPknRb9Y20WQbDbNYEjqK7ERVNSupHSXiIQKNGhswz1k=
Date: Thu, 3 Jan 2008 15:16:23 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tomas Carnecky <tom@dbservice.com>
Cc: joern@logfs.org, Ingo_Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       David_Woodhouse <dwmw2@infradead.org>
Subject: Re: [x86] kernel/audit.c cleanup according to checkpatch.pl
Message-ID: <20080103121623.GF8046@cvg>
References: <20080103111925.GC8046@cvg> <20080103112957.GA14693@lazybastard.org> <20080103114642.GD8046@cvg> <477CD0B4.5000408@dbservice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <477CD0B4.5000408@dbservice.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Tomas Carnecky - Thu, Jan 03, 2008 at 01:10:28PM +0100]
> Cyrill Gorcunov wrote:
>> [=?ISO-8859-1?Q?J=F6rn_Engel_ - Thu, Jan 03, 2008 at 12:29:57PM +0100]
>> | On Thu, 3 January 2008 14:19:25 +0300, Cyrill Gorcunov wrote:
>> | > @@ -232,7 +232,8 @@ void audit_log_lost(const char *message)
>> | >  | >  	if (print) {
>> | >  		printk(KERN_WARNING
>> | > -		       "audit: audit_lost=%d audit_rate_limit=%d 
>> audit_backlog_limit=%d\n",
>> | > +		       "audit: audit_lost=%d audit_rate_limit=%d "
>> | > +		       "audit_backlog_limit=%d\n",
>> | >  		       atomic_read(&audit_lost),
>> | >  		       audit_rate_limit,
>> | >  		       audit_backlog_limit);
>> | | This hunk is a bit questionable.  It can easily deceive a reader to
>> | assume two seperate lines printed out and sometimes defeats grepping
>> | for printk output to find the code generating the message.
>> | | Rest looks good to me.
>> | | Jörn
>> | | -- | He that composes himself is wiser than he that composes a book.
>> | -- B. Franklin
>> | indeed.
>> here is updated one (with these part removed)
>
> Instead of removing that part completely, why not print this:
> "audit: lost=%d rate_limit=%d backlog_limit=%d\n"
>
> In that line there were too many 'audit's IMHO, and if someone wants to 
> grep 'audit_lost=' he still can, 'audit:.*lost=' or something like that..
>
> tom
>

Well, it seems David is a mainteiner of this code,
so if he would not argue against this the we could.

		- Cyrill -
