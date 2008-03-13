Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbYCMOxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbYCMOxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 10:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbYCMOx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 10:53:26 -0400
Received: from nebensachen.de ([195.34.83.29]:40948 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbYCMOxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 10:53:25 -0400
X-Hashcash: 1:20:080313:alan@lxorguk.ukuu.org.uk::ZQxSu6z84pZ0NOYd:00000000000000000000000000000000000000gNk
X-Hashcash: 1:20:080313:linux-ide@vger.kernel.org::Ojc/29cy2Q49AP0C:0000000000000000000000000000000000006DQ8
X-Hashcash: 1:20:080313:linux-kernel@vger.kernel.org::GZLoOPMqNWl1NYYr:0000000000000000000000000000000001R4q
X-Hashcash: 1:20:080313:jens.axboe@oracle.com::6n3n+gxQE7tH0fQD:00000000000000000000000000000000000000003V4h
From: Elias Oltmanns <eo@nebensachen.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] Disk shock protection (revisited)
References: <87skzgd1zk.fsf@denkblock.local> <20080226123946.75dbe3d2@core>
	<87mypl8p49.fsf@denkblock.local> <20080228111349.6831925c@core>
	<87bq5qfm2v.fsf@denkblock.local>
Mail-Copies-To: nobody
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe
	<jens.axboe@oracle.com>
Date: Thu, 13 Mar 2008 15:51:59 +0100
In-Reply-To: <87bq5qfm2v.fsf@denkblock.local> (Elias Oltmanns's message of
	"Fri, 07 Mar 2008 19:03:36 +0100")
Message-ID: <8763vq8ynk.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns <eo@nebensachen.de> wrote:
[...]
> I'm going to send a first draft of a patch series in reply to this
> email. It is a stripped down version intended to get the general idea
> across.

Have you had got round to looking at these patches yet?

> The first of these four patches will eventually need to be modified to
> actually abort in flight commands and clear up the mess afterwards.
> However, first and foremost I'd like to draw your attention to the use
> of REQ_TYPE_LINUX_BLOCK requests as demonstrated in the other three
> patches. The question is whether the underlying concept is right.
> Although the question how to handle REQ_TYPE_LINUX_BLOCK requests in
> the scsi subsystem has been raised on the linux-scsi ml, it has never
> been answered really because this request type was deemed unsuitable
> for the application in question. See, for instance, the thread
> starting at [1]. My patch approach has been partly inspired by the
> patch discussed there. Before I raise this issue yet again, I'd like
> to know whether REQ_TYPE_LINUX_BLOCK is the right choice for my
> application in your opinion or whether another mechanism might be more
> suitable as James suggested a while ago (see [2]).
>
> Regards,
>
> Elias
>
> [1] http://permalink.gmane.org/gmane.linux.scsi/30049
> [2] http://permalink.gmane.org/gmane.linux.scsi/37951

Sorry, I got these two the wrong way round. [1] should be [2] and vice
versa.

Regards,

Elias
