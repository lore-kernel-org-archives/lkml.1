Return-Path: <linux-kernel-owner+w=401wt.eu-S964944AbXBTOfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964944AbXBTOfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 09:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964936AbXBTOfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 09:35:10 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:41454 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964951AbXBTOfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 09:35:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=bN730LQet38bMGl14m6rrnpPsYZh7udUYKMwv4rqLljr0mATit99BjCarimVE4WA4440D5VJImuCR+93iMFC28cvrRHi+FdofwbHfthWW7/OLVAxHerCWJBwdwKQvNuRCTa1Ms29IBMWhcJqdNUDl6cO4yst0FX3y15L7i8y+v8=
Message-ID: <45DB0717.90507@gmail.com>
Date: Tue, 20 Feb 2007 23:35:03 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Pablo Sebastian Greco <lkml@fliagreco.com.ar>
CC: Marcus Haebler <haebler@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: SATA problems
References: <459A674B.3060304@fliagreco.com.ar> <459B9F91.9070908@gmail.com>	 <459BC703.9000207@fliagreco.com.ar> <459C8A5E.5010206@gmail.com>	 <459CFE7B.6090306@fliagreco.com.ar>	 <459DC2EE.1090307@fliagreco.com.ar> <45A1AB3F.1080408@gmail.com>	 <45B649BF.5030705@fliagreco.com.ar> <45B6BC6D.8070301@gmail.com> <d72aa1340702170449n1aa61777l6c9c7e525102db00@mail.gmail.com> <45D731A8.90604@fliagreco.com.ar>
In-Reply-To: <45D731A8.90604@fliagreco.com.ar>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Pablo, the bug you saw was bad interaction between blacklisted NCQ
device and dynamic queue depth adjustment.  Patches are submitted to fix
the problem.  Just drop the blacklist patch.  Your drives should work
fine in NCQ mode.  My gut feeling is that your problem is power related
from the beginning.

* Marcus, you're on via's ahci controller, right?  The problem you saw
was bad interaction between blacklisted NCQ _controller_ and dynamic
queue depth adjustment.  Patches submitted.

Thanks.

-- 
tejun
