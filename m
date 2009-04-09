Return-Path: <linux-kernel-owner+w=401wt.eu-S933271AbZDIMiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271AbZDIMiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 08:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765394AbZDIMh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 08:37:58 -0400
Received: from vps1.tull.net ([66.180.172.116]:53678 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761708AbZDIMh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 08:37:57 -0400
Date: Thu, 9 Apr 2009 22:36:44 +1000
From: Nick Andrew <nick@nick-andrew.net>
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: Sino <szj087@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: the different effect of system call fork()
Message-ID: <20090409123644.GA10495@mail.local.tull.net>
References: <cab3445d0904080553k6fc67498s73cb5b7c661ff0b@mail.gmail.com> <1239196128.5031.3.camel@spike.firmix.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239196128.5031.3.camel@spike.firmix.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 03:08:48PM +0200, Bernd Petrovitsch wrote:
> >    if (pid_t pid = fork() < 0)
> 
> I don't think that this line does what you want it to do.
> Hint: Using a "pid_t" for the boolean result for a comparison seems
> strange at best.

The "problem" is due to a misunderstanding of C/C++ operator precedence.

"(pid = fork() < 0)" binds like "pid = (fork() < 0)" and so pid always
has a value of zero and so both parent and child process run the "first
level child process" code ... soon there are 4 processes all confused
about who they are.

Nick.
