Return-Path: <linux-kernel-owner+w=401wt.eu-S1760346AbXE2PTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760346AbXE2PTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 11:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbXE2PTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 11:19:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:40888 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbXE2PTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 11:19:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JU435ijtQ/H8sAyRoPLWsBBBjdEZqIa5CS/GngnQNd5XRiANmU22SML9Cgsv13j095hG83pEvAAtcsERGV6FC0NW3aV/71z25AnfLqrv66tJ/72I2pPW/plcxVhTBJght5GAg1rsCKbZOt5bTTjEwzUD2BvP0tryxGFXOV3bCo0=
Message-ID: <9d2cd630705290819m1e52059cwc749c18e284dffbe@mail.gmail.com>
Date: Tue, 29 May 2007 17:19:32 +0200
From: "Gregor Jasny" <gjasny@googlemail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: Linux v2.6.22-rc3
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jeff Garzik" <jgarzik@pobox.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <465BF244.5080200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>
	 <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>
	 <46599E6B.1000209@pobox.com>
	 <9d2cd630705270907y4722653cpf79f073fa8f12f08@mail.gmail.com>
	 <alpine.LFD.0.98.0705270922030.26602@woody.linux-foundation.org>
	 <9d2cd630705271315x7030c91ew2f175c921c022880@mail.gmail.com>
	 <465AA536.6080608@gmail.com>
	 <9d2cd630705280707h4921900fxc93a07a87f0bdf66@mail.gmail.com>
	 <465BF244.5080200@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/29, Tejun Heo <htejun@gmail.com>:
> Aieee, so the drive doesn't like the new SRST sequence.  Indan pointed
> me to your original posting and before the reset sequence update your
> drive was reset successfully but only after 30sec delay, right?  If you
> change the first entry in ata_eh_reset_timeouts[] table at the top of
> libata-eh.c to 35 * HZ, does it work?

No, it even times out after 35 seconds. I've raised the first timeout
to 60 seconds but still no success.
