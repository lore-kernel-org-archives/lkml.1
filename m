Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbYCDIz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbYCDIz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYCDIzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:55:16 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:13252 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbYCDIzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:55:15 -0500
Subject: Re: [PATCH 06/14] drivers/s390: replace remaining __FUNCTION__
	occurrences
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1204600187.22933.86.camel@brick>
References: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
	 <1204600187.22933.86.camel@brick>
Content-Type: text/plain
Organization: IBM Corporation
Date: Tue, 04 Mar 2008 09:55:07 +0100
Message-Id: <1204620907.1278.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-03 at 19:09 -0800, Harvey Harrison wrote:
> __FUNCTION__ is gcc-specific, use __func__
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/s390/block/dasd.c        |    4 +-
>  drivers/s390/char/tape_34xx.c    |    2 +-
>  drivers/s390/char/vmwatchdog.c   |    4 +-
>  drivers/s390/char/zcore.c        |    2 +-
>  drivers/s390/cio/device_status.c |    2 +-
>  drivers/s390/crypto/zcrypt_api.h |    8 +-
>  drivers/s390/net/claw.c          |  344 +++++++++++++++++++-------------------
>  drivers/s390/net/ctcmain.c       |  112 ++++++------
>  drivers/s390/net/netiucv.c       |   96 ++++++------
>  drivers/s390/s390mach.c          |    8 +-
>  drivers/s390/scsi/zfcp_def.h     |    2 +-
>  11 files changed, 292 insertions(+), 292 deletions(-)

Urgh, is this really necessary? The linux kernel is always compiled with
gcc for s390. Yes __func__ is a bit shorter and maybe even looks nicer
than __FUNCTION__ but is it really worth the trouble ? 

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


