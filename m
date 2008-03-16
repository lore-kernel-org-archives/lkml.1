Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbYCPX7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbYCPX7u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 19:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYCPX7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 19:59:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbYCPX7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:59:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Laurent Riffard <laurent.riffard@free.fr>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] don't panic if /sbin/init exits or killed
In-Reply-To: Oleg Nesterov's message of  Monday, 17 March 2008 02:49:29 +0300 <20080316234929.GA456@tv-sign.ru>
References: <20080316155453.GA20845@tv-sign.ru>
	<20080316221938.D217026F995@magilla.localdomain>
	<20080316230346.GA379@tv-sign.ru>
	<20080316233242.DC9E226F995@magilla.localdomain>
	<20080316234929.GA456@tv-sign.ru>
X-Windows: the joke that kills.
Message-Id: <20080316235934.22B8626F9E9@magilla.localdomain>
Date: Sun, 16 Mar 2008 16:59:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ah, OK. We can change this to dump_stack() without BUG().

I'm not sure that's a whole lot better as far as confusion.  
And what use is it?  You know init exited.  Just print its exit_code 
and/or group_exit_code and you know what kind of kernel entry the exit was.


Thanks,
Roland
