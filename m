Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbXITH0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbXITH0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758621AbXITH0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:26:16 -0400
Received: from smtp.seznam.cz ([77.75.72.43]:60765 "HELO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754533AbXITH0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:26:12 -0400
From: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
To: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Date: Thu, 20 Sep 2007 09:30:36 +0200
MIME-Version: 1.0
Subject: Re: [newbie:] Bonnie++2 hangs recent 2.6 kernels? Bash keeps looping in waitpid(), eating 100% CPU
Message-ID: <46F23DBC.22094.4C2C2616@localhost>
In-reply-to: <46F1A870.2020109@redhat.com>
References: <46EABE19.27660.2EE1940D@localhost>
X-mailer: Pegasus Mail for Windows (4.21c)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Smtpd: 1.0.12@11920:11921
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 Sep 2007 at 0:53, Chuck Ebbert wrote:
> Looks like process 2382 is stuck with the kernel trying to send
> SIGBUS to that bash process, here:
> 
Wow, thanks for that hint, certainly I wouldn't be able to trace the 
problem as far as this :-)

Does this mean that perhaps bash or glibc (my outdated versions) 
inappropriately mask SIGBUS, and it's therefore a bug in my user 
space ?

Frank Rysanek
