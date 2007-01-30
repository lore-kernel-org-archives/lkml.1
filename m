Return-Path: <linux-kernel-owner+w=401wt.eu-S965253AbXA3Hgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965253AbXA3Hgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 02:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965423AbXA3Hgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 02:36:46 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42963 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965253AbXA3Hgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 02:36:45 -0500
Message-ID: <45BEF582.7080004@hitachi.com>
Date: Tue, 30 Jan 2007 16:36:34 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
Cc: akpm@osdl.org, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, alan@lxorguk.ukuu.org.uk,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 0/4] coredump: core dump masking support v2
References: <45BA0A93.30004@hitachi.com> 
    <20070126152907.GB30950@lnx-holt.americas.sgi.com>
In-Reply-To: <20070126152907.GB30950@lnx-holt.americas.sgi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robin,

Robin Holt wrote:
> Can you make this a little more transparent?  Having a magic bitmask does
> not seem like the best way to do stuff.  Could you maybe make a core_flags
> directory with a seperate file for each flag.  It could still map to a
> single field in the mm, but be broken out for the proc filesystem.

It seems to be one of the good enhancement idea, thanks.:-)
But currently, there is only one flag. So we had better keep this simple
implementation until someone requests to add a new flag.

Thanks,
-- 
Hidehiro Kawai
Hitachi, Ltd., Systems Development Laboratory



