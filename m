Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbXIDOOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbXIDOOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 10:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbXIDOOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 10:14:25 -0400
Received: from smtpout.mac.com ([17.250.248.178]:64624 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779AbXIDOOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 10:14:24 -0400
In-Reply-To: <200709042302.CDE26023.MJOOLQVFFOtHSF@I-love.SAKURA.ne.jp>
References: <46CED214.6050505@gmail.com> <200708280921.48867.paul.moore@hp.com> <200709032215.DCF36819.SLQtHFMFOOFOVJ@I-love.SAKURA.ne.jp> <200709040753.32204.paul.moore@hp.com> <200709042302.CDE26023.MJOOLQVFFOtHSF@I-love.SAKURA.ne.jp>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <2F57DE1C-8F5F-4AE3-B61D-B1405BD0B098@mac.com>
Cc: paul.moore@hp.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, chrisw@sous-sol.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [TOMOYO 15/15] LSM expansion for TOMOYO Linux.
Date: Tue, 4 Sep 2007 10:13:27 -0400
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 04, 2007, at 10:02:46, Tetsuo Handa wrote:
> Hmm, I can't understand why I have to perform access control at  
> "enqueue" time.
>
> What I want to do is
>   allow process1 receive UDP packets from 10.0.0.1 port 1024
>   allow process2 receive UDP packets from 10.0.0.2 port 2048
> when there is no guarantee that process1 and process2 are not  
> sharing a socket.
>
> If there is guarantee that process1 and process2 are not sharing a  
> socket,
> I can do it using netfilter.

Well, we used to be able to do that with netfilter but it had the  
same unfixable race conditions that you are presently running into  
and so such support was dropped by the netfilter folks.  I suspect if  
you CC'ed netdev@vger.kernel.org you would get some very precise  
reasons why such filtering doesn't work.

Cheers,
Kyle Moffett

