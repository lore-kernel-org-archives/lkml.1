Return-Path: <linux-kernel-owner+w=401wt.eu-S1755065AbYAEBHC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbYAEBHC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 20:07:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbYAEBGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 20:06:52 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:40109 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbYAEBGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 20:06:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=eLzAHQYteT/irNHSvfuWPQujf6rroqFVfi6QDcRP2cGUMQ+weX+K+kC0bKzJOTqELbdT1lx6DbVcccgh78Nk6KEccxXRMm4U8V9pOK6SAb99PdSpc8HyT+7PthkP+euqwZ5fLc8WOjgdWu3C4BRp0K/aeaZbphTHP0dul7LMGTc=
Date: Sat, 5 Jan 2008 02:06:39 +0100
From: Frederik Deweerdt <deweerdt@free.fr>
To: Phil Endecott <phil_wueww_endecott@chezphil.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: strace, accept(), ERESTARTSYS and EINTR
Message-ID: <20080105010639.GA8417@slug>
References: <1199480498017@dmwebmail.japan.chezphil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199480498017@dmwebmail.japan.chezphil.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 09:01:38PM +0000, Phil Endecott wrote:
> Dear Experts,
> 
> I have some code like this:
> 
> struct sockaddr_in client_addr;
> socklen_t client_size=sizeof(client_addr);
> int connfd = accept(fd,(struct sockaddr*)(&client_addr),&client_size);
> if (connfd==-1) {
>   // [1]
>   .....report error and terminate......
Replacing the (connfd == -1) check with (connfd < 0),
could you try printf'ing connfd and errno here?
Just to confirm strace's output.
> }
> int rc = fcntl(connfd,F_SETFD,FD_CLOEXEC);
> 
Regards,
Frederik
