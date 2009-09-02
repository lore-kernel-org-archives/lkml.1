Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbZIBFnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbZIBFnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 01:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbZIBFnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 01:43:51 -0400
Received: from smtp.nokia.com ([192.100.105.134]:51619 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776AbZIBFnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 01:43:50 -0400
Message-ID: <4A9E05D4.4050206@nokia.com>
Date: Wed, 02 Sep 2009 08:42:44 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Jens Axboe <jens.axboe@oracle.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the block tree with the ubifs tree
References: <20090902153657.dc174bf6.sfr@canb.auug.org.au>
In-Reply-To: <20090902153657.dc174bf6.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Sep 2009 05:43:17.0297 (UTC) FILETIME=[45645A10:01CA2B90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2009 08:36 AM, ext Stephen Rothwell wrote:
> Hi Jens,
>
> Today's linux-next merge of the block tree got a conflict in
> fs/ubifs/super.c between commit 887ee17117fd23e962332b353d250ac9e090b20f
> ("UBIFS: remove unneeded call from ubifs_sync_fs") from the ubifs tree
> and commit 0184fca792940a9e4058b2c63b3f334326a4c7af ("writeback: move
> super_block argument to struct writeback_control") from the block tree.
>
> The former removes the code that the latter changes.  I just used the
> version from the ubifs tree.  I can carry this fixup as necessary.

Yeah, I remove the call because it is not needed anymore.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
