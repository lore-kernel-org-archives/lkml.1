Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbXJBPht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbXJBPht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbXJBPhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:37:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbXJBPhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:37:41 -0400
Message-ID: <470265C1.5040006@redhat.com>
Date: Tue, 02 Oct 2007 17:37:37 +0200
From: Michal Schmidt <mschmidt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070718)
MIME-Version: 1.0
To: Yakov Lerner <iler.ml@gmail.com>
CC: Kernel Linux <linux-kernel@vger.kernel.org>
Subject: Re: get amount of "entropy" in /dev/random ?
References: <f36b08ee0710020825x559a1046n6b7a2070d5591320@mail.gmail.com>
In-Reply-To: <f36b08ee0710020825x559a1046n6b7a2070d5591320@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=979FF3AA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yakov Lerner wrote:
> >From the userlevel, can I get an estimate of  "amount of entropy"
> in /dev/random, that is, the estimate of number of bytes
> readable until it blocks ? Of course multiple processes
> can read bytes and this would not be exact ... but still .. as an upper
> boundary estimate ?
>
> Thanks
> Yakov

Try ioctl(fd, RNDGETENTCNT, &entropy_count)

Michal

