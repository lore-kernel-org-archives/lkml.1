Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbYCQAGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbYCQAGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 20:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYCQAGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 20:06:09 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:60264 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbYCQAGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 20:06:08 -0400
Date: Mon, 17 Mar 2008 03:05:20 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Laurent Riffard <laurent.riffard@free.fr>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] don't panic if /sbin/init exits or killed
Message-ID: <20080317000520.GA542@tv-sign.ru>
References: <20080316155453.GA20845@tv-sign.ru> <20080316221938.D217026F995@magilla.localdomain> <20080316230346.GA379@tv-sign.ru> <20080316233242.DC9E226F995@magilla.localdomain> <20080316234929.GA456@tv-sign.ru> <20080316235934.22B8626F9E9@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080316235934.22B8626F9E9@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16, Roland McGrath wrote:
>
> > Ah, OK. We can change this to dump_stack() without BUG().
> 
> I'm not sure that's a whole lot better as far as confusion.  
> And what use is it?  You know init exited.  Just print its exit_code 
> and/or group_exit_code and you know what kind of kernel entry the exit was.

Agreed. It was either killed, or exited. The exit code provides enough info.

Thanks, I'll resend this patch.

Oleg.

