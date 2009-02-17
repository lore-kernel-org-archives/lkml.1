Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbZBQPKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbZBQPKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZBQPJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:09:45 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:53738 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZBQPJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:09:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=Jt+R1y8ZllAd9UAOpyx1CGQuOzLKOFmniUX5qFMnDm4IdFisN42/XmflOLAAJ2Vy1h
         Xvxrbte7UMNmP+WBG7zlenUaAmPrqiUN5GWERc2UWSWwybwps7Q0O1uhNxE9aKd1pXB3
         0anKFqRsiXMEmlqdzBAOCpfLPwK680GWzkFWU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 0/10] ide: flags query macros
Date: Tue, 17 Feb 2009 15:33:28 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-next-20090216; KDE/4.2.0; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1234699692-9452-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1234699692-9452-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902171533.29135.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 February 2009, Borislav Petkov wrote:
> Hi,
> 
> this series adds the drive->atapi_flags and drive->dev_flags macro wrappers
> we discussed. The idea was to make the code more readable and this has
> been my main concern when coming up with the macro naming, therefore
> some macro names appear a tad more descriptive than the flag itself.
> 
>  drivers/ide/cmd640.c           |    2 +-
>  drivers/ide/ht6560b.c          |    3 +-
>  drivers/ide/ide-atapi.c        |   15 ++++++-------
>  drivers/ide/ide-cd.c           |   44 ++++++++++++++++++++-------------------
>  drivers/ide/ide-cd_ioctl.c     |   18 +++++++---------
>  drivers/ide/ide-devsets.c      |    8 ++----
>  drivers/ide/ide-disk.c         |   32 ++++++++++++++--------------
>  drivers/ide/ide-disk_proc.c    |    2 +-
>  drivers/ide/ide-dma.c          |    3 +-
>  drivers/ide/ide-eh.c           |   17 +++++++--------
>  drivers/ide/ide-floppy.c       |    6 ++--
>  drivers/ide/ide-floppy_ioctl.c |    2 +-
>  drivers/ide/ide-gd.c           |   14 ++++++------
>  drivers/ide/ide-io.c           |    9 +++----
>  drivers/ide/ide-ioctls.c       |    6 ++--
>  drivers/ide/ide-iops.c         |    6 ++--
>  drivers/ide/ide-lib.c          |    2 +-
>  drivers/ide/ide-park.c         |   11 ++++-----
>  drivers/ide/ide-pm.c           |    2 +-
>  drivers/ide/ide-probe.c        |   36 +++++++++++++++++---------------
>  drivers/ide/ide-proc.c         |    2 +-
>  drivers/ide/ide-tape.c         |   12 +++++-----
>  drivers/ide/ide-taskfile.c     |   16 +++++---------
>  drivers/ide/ns87415.c          |    5 +--
>  drivers/ide/pdc202xx_old.c     |    4 +-
>  drivers/ide/sc1200.c           |    2 +-
>  drivers/ide/trm290.c           |    4 +-
>  27 files changed, 136 insertions(+), 147 deletions(-)

One more thing I forgot yesterday:

Since it is not a lot of modified lines and the change is rather
straightforward it could as well be done in a single patch...

Thanks,
Bart
