Return-Path: <linux-kernel-owner+w=401wt.eu-S1752529AbYJFIDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbYJFIDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 04:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbYJFIDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 04:03:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:40508 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbYJFIDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 04:03:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=nJBc3XCRpB03nxdaq2ypXDiyl1tVGfl3FX4I1ynP9YEt9pWupZWTjepbirS9O/MUvO
         Tspv5+Dr/aqRHh5IS6D1LMKkEbFnZMiW0JOltwWdohOQhg8wsliVPA2w7sl5CxQZzOqd
         tnEMeTUfXWBSsT9aRpGmcfVxRs2pv4utn+2Wo=
Message-ID: <48E9C637.8030507@gmail.com>
Date: Mon, 06 Oct 2008 10:03:03 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Marco Innocenti <m.innocenti@cineca.it>,
       matt@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/6] introduce struct res_counter_ratelimit
References: <1221649528-8519-3-git-send-email-righi.andrea@gmail.com> <6599ad830810051103v1bd6e8d4xd2fcf622558fc7d9@mail.gmail.com>
In-Reply-To: <6599ad830810051103v1bd6e8d4xd2fcf622558fc7d9@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> Hi Andrea,
> 
> The principle seems useful, but you seem to be duplicating a lot of
> the existing res_counter code.

Agree.

> 
> Could you not either:
> 
> - include these two extra fields in res_counter?
> - include res_counter as the first field in a res_counter_ratelimit?

The second solution would save some space if the "ratelimit" part is not used.
Anyway, I'll try to rewrite it to reuse as much code as possible and post a new
patchset.

Thanks for looking into it.

-Andrea
