Return-Path: <linux-kernel-owner+w=401wt.eu-S932209AbXBUAzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbXBUAzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 19:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932244AbXBUAzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 19:55:22 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:42869 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209AbXBUAzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 19:55:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VaidkB/ig5vSjEIJTSu6HTwsCpacq6aCuoKZkDHSc9S3/a50woV7/VxbftxQYb8HeZW6RLEr7BNLHGR6F5OWthyvcYBlrfQPeLbmvQTaYGKkdS7PKh5EcZEAVgjpSAMjaQoDIsNjewtmgLeNGH4pc1ffXUJwjmIhM0iCpto7Z2Q=
Message-ID: <d72aa1340702201655o78975cc7vd67c82eea92bd519@mail.gmail.com>
Date: Tue, 20 Feb 2007 19:55:20 -0500
From: "Marcus Haebler" <haebler@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: SATA problems
Cc: "Pablo Sebastian Greco" <lkml@fliagreco.com.ar>,
       linux-kernel@vger.kernel.org
In-Reply-To: <45DB0717.90507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <459A674B.3060304@fliagreco.com.ar> <459C8A5E.5010206@gmail.com>
	 <459CFE7B.6090306@fliagreco.com.ar>
	 <459DC2EE.1090307@fliagreco.com.ar> <45A1AB3F.1080408@gmail.com>
	 <45B649BF.5030705@fliagreco.com.ar> <45B6BC6D.8070301@gmail.com>
	 <d72aa1340702170449n1aa61777l6c9c7e525102db00@mail.gmail.com>
	 <45D731A8.90604@fliagreco.com.ar> <45DB0717.90507@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

thanks for the patches! I am on an Intel P965/ICH8R.

Best,

Marcus

On 2/20/07, Tejun Heo <htejun@gmail.com> wrote:
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
> --
> tejun
>
