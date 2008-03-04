Return-Path: <linux-kernel-owner+w=401wt.eu-S1761720AbYCDJQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761720AbYCDJQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 04:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbYCDJQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 04:16:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752489AbYCDJQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:16:08 -0500
Date: Tue, 4 Mar 2008 01:15:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: schwidefsky@de.ibm.com
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/14] drivers/s390: replace remaining __FUNCTION__
 occurrences
Message-Id: <20080304011521.98a20055.akpm@linux-foundation.org>
In-Reply-To: <1204620907.1278.7.camel@localhost>
References: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
	<1204600187.22933.86.camel@brick>
	<1204620907.1278.7.camel@localhost>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Mar 2008 09:55:07 +0100 Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Mon, 2008-03-03 at 19:09 -0800, Harvey Harrison wrote:
> > __FUNCTION__ is gcc-specific, use __func__
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> >  drivers/s390/block/dasd.c        |    4 +-
> >  drivers/s390/char/tape_34xx.c    |    2 +-
> >  drivers/s390/char/vmwatchdog.c   |    4 +-
> >  drivers/s390/char/zcore.c        |    2 +-
> >  drivers/s390/cio/device_status.c |    2 +-
> >  drivers/s390/crypto/zcrypt_api.h |    8 +-
> >  drivers/s390/net/claw.c          |  344 +++++++++++++++++++-------------------
> >  drivers/s390/net/ctcmain.c       |  112 ++++++------
> >  drivers/s390/net/netiucv.c       |   96 ++++++------
> >  drivers/s390/s390mach.c          |    8 +-
> >  drivers/s390/scsi/zfcp_def.h     |    2 +-
> >  11 files changed, 292 insertions(+), 292 deletions(-)
> 
> Urgh, is this really necessary? The linux kernel is always compiled with
> gcc for s390. Yes __func__ is a bit shorter and maybe even looks nicer
> than __FUNCTION__ but is it really worth the trouble ? 
> 

That's what everyone is asking ;)

Unfortunately, __func__ is preferred and __FUNCTION__ is deprecated.  So
the patch converts your code from "wrong" to "right".  Even though it was
only a teeny bit wrong.

