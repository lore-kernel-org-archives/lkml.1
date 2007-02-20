Return-Path: <linux-kernel-owner+w=401wt.eu-S1030192AbXBTQZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030192AbXBTQZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:25:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030217AbXBTQZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:25:12 -0500
Received: from mail.icabo.tv.br ([200.220.202.3]:37160 "EHLO mail.icabo.tv.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030192AbXBTQZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:25:10 -0500
Message-ID: <45DB20CF.7080300@fliagreco.com.ar>
Date: Tue, 20 Feb 2007 13:24:47 -0300
From: Pablo Sebastian Greco <lkml@fliagreco.com.ar>
User-Agent: Thunderbird 3.0a1 (Windows/20070219)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Marcus Haebler <haebler@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: SATA problems
References: <459A674B.3060304@fliagreco.com.ar> <459B9F91.9070908@gmail.com>	 <459BC703.9000207@fliagreco.com.ar> <459C8A5E.5010206@gmail.com>	 <459CFE7B.6090306@fliagreco.com.ar>	 <459DC2EE.1090307@fliagreco.com.ar> <45A1AB3F.1080408@gmail.com>	 <45B649BF.5030705@fliagreco.com.ar> <45B6BC6D.8070301@gmail.com> <d72aa1340702170449n1aa61777l6c9c7e525102db00@mail.gmail.com> <45D731A8.90604@fliagreco.com.ar> <45DB0717.90507@gmail.com>
In-Reply-To: <45DB0717.90507@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ICABO-MailScanner-Information: Please contact the ISP for more information
X-ICABO-MailScanner: Sem Virus encontrado
X-MailScanner-From: lkml@fliagreco.com.ar
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> * Pablo, the bug you saw was bad interaction between blacklisted NCQ
> device and dynamic queue depth adjustment.  Patches are submitted to fix
> the problem.  Just drop the blacklist patch.  Your drives should work
> fine in NCQ mode.  My gut feeling is that your problem is power related
> from the beginning.
>
> * Marcus, you're on via's ahci controller, right?  The problem you saw
> was bad interaction between blacklisted NCQ _controller_ and dynamic
> queue depth adjustment.  Patches submitted.
>
> Thanks.
>
>   
I had the same problems with a new Power Supply, Now everything is ok 
with the old Power Supply and the new drives.

Pablo.
