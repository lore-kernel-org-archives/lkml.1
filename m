Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbYDAHj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbYDAHj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 03:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYDAHjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 03:39:17 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:52710 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbYDAHjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 03:39:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Tf3We4b6dkcdwxkdXh5Re4lANS4plGQGPewglrVOe8ZSoDL6xyOyAC7d45wOjXxSNq9GP5ymjZI4PnlQSIWsr4+LkuiGe2y23gOZZsrerYP1DsuIZLKywLD5DtxlNTyuOjnMs2Jii6NWlMBcqxlr4fgWD0U5RLDScjyYqJnOOvU=
Message-ID: <84144f020804010039n47133bd3l63f02258a2670e72@mail.gmail.com>
Date: Tue, 1 Apr 2008 10:39:13 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Artem Bityutskiy" <Artem.Bityutskiy@nokia.com>
Subject: Re: [RFC PATCH 26/26] UBIFS: include FS to compilation
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Adrian Hunter" <ext-adrian.hunter@nokia.com>
In-Reply-To: <1206629746-4298-27-git-send-email-Artem.Bityutskiy@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
	 <1206629746-4298-27-git-send-email-Artem.Bityutskiy@nokia.com>
X-Google-Sender-Auth: 466f911774fb7391
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

On Thu, Mar 27, 2008 at 5:55 PM, Artem Bityutskiy
<Artem.Bityutskiy@nokia.com> wrote:
>  +config UBIFS_FS_DEBUG_MSG_GEN
>  +
>  +config UBIFS_FS_DEBUG_MSG_JRN
>  +
>  +config UBIFS_FS_DEBUG_MSG_CMT
>  +
>  +config UBIFS_FS_DEBUG_MSG_BUDG
>  +
>  +config UBIFS_FS_DEBUG_MSG_LOG
>  +
>  +config UBIFS_FS_DEBUG_MSG_TNC
>  +
>  +config UBIFS_FS_DEBUG_MSG_LP
>  +
>  +config UBIFS_FS_DEBUG_MSG_FIND
>  +
>  +config UBIFS_FS_DEBUG_MSG_MNT
>  +
>  +config UBIFS_FS_DEBUG_MSG_IO
>  +
>  +config UBIFS_FS_DEBUG_MSG_GC
>  +
>  +config UBIFS_FS_DEBUG_MSG_SCAN

But these don't make much sense to me. Why would you want to be able
to compile out printks at this granularity? Why not enable all of them
when CONFIG_UBIFS_FS_DEBUG is enabled?

>  +menu "Extra self-checks"
>  +       depends on UBIFS_FS_DEBUG
>  +
>  +config UBIFS_FS_DEBUG_CHK_MEMPRESS

>  +config UBIFS_FS_DEBUG_CHK_LPROPS
>  +
>  +config UBIFS_FS_DEBUG_CHK_TNC
>  +
>  +config UBIFS_FS_DEBUG_CHK_ORPH
>  +
>  +config UBIFS_FS_DEBUG_CHK_IDX_SZ
>  +
>  +config UBIFS_FS_DEBUG_CHK_OLD_IDX
>  +
>  +config UBIFS_FS_DEBUG_CHK_OTHER
>  +
>  +config UBIFS_FS_DEBUG_TEST_RCVRY

Why would you not want to enable all of these for development kernels?
