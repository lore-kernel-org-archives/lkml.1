Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbZJ2NvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbZJ2NvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 09:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbZJ2NvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 09:51:05 -0400
Received: from mail-forward1.uio.no ([129.240.10.70]:48660 "EHLO
	mail-forward1.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbZJ2NvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 09:51:02 -0400
References: <4AE72079.4030504@simula.no> <4AE7B887.6090806@gmail.com>
In-Reply-To: <4AE7B887.6090806@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Message-Id: <F7D530D6-304E-4B99-8143-9E197AF8D74E@simula.no>
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, ilpo.jarvinen@helsinki.fi, davem@davemloft.net
From: Andreas Petlund <apetlund@simula.no>
Subject: Re: [PATCH 2/3] net: TCP thin linear timeouts
Date: Thu, 29 Oct 2009 14:50:48 +0100
To: William Allen Simpson <william.allen.simpson@gmail.com>
X-Mailer: Apple Mail (2.1076)
X-UiO-Ratelimit-Test: rcpts/h 7 msgs/h 2 sum rcpts/h 9 sum msgs/h 2 total rcpts 369 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-4.5, required=5.0, autolearn=disabled, TVD_RCVD_IP=0.502,UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 86FD58181B5E1C825C11F9CEEDC215BB59A77988
X-UiO-SPAM-Test: remote_host: 213.23.10.108 spam_score: -44 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 2 max/h 2 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Den 28. okt. 2009 kl. 04.20 skrev William Allen Simpson:

> Sorry to be too picky about the naming, but "rm_expb" really doesn't
> mean what is actually done.  Perhaps TCP_THIN_LINEAR_BACKOFF and
> sysctl_tcp_thin_linear_backoff?
>

I agree that the name should be changed. As it represents linear  
timeouts and does not back off exponentially, I suggest  
TCP_THIN_LINEAR_TIMEOUTS and sysctl_tcp_thin_linear_timeouts.

> Also, as debated on some other recent patches, shouldn't the global
> sysctl specify the default, and the per socket option specify the
> forced override?

The rationale behind the suggested model is to allow the modifications  
to be forced active in cases where the application that generates the  
thin stream is proprietary, legacy, or that the code for other reasons  
can not be modified (as is the case, for instance, for many game  
clients).
