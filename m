Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbXCZPcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbXCZPcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 11:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbXCZPcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 11:32:03 -0400
Received: from mail.parknet.jp ([210.171.160.80]:1542 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbXCZPcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 11:32:01 -0400
X-AuthUser: hirofumi@parknet.jp
To: Hiroyuki Machida <Hiroyuki_Machida@hq.scei.sony.co.jp>
Cc: Paul Collins <paul@briny.ondioline.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fat/vfat: optionally ignore system timezone offset when reading/writing timestamps
References: <OFE734E183.0E10CA2B-ON492572AA.00132685-492572AA.0016700F@hq.scei.sony.co.jp>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Tue, 27 Mar 2007 00:31:50 +0900
In-Reply-To: <OFE734E183.0E10CA2B-ON492572AA.00132685-492572AA.0016700F@hq.scei.sony.co.jp> (Hiroyuki Machida's message of "Mon\, 26 Mar 2007 13\:05\:10 +0900")
Message-ID: <87ps6whvh5.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroyuki Machida <Hiroyuki_Machida@hq.scei.sony.co.jp> writes:

> I'm not famillar with recent fat code, but code itself looks good for
> just turn on/off time adjusting. On the other hand, I feel we need more 
> consideration on use cases/requirements. I feel that turning off
> time adjustment is a just ad-hoc solution to issues like Paul san 
> brought up.

Thank you. I see. So we need "timezone" option to specify adjusted
time?  If so, I feel we can add it as "timezone=utc", then it'll can
be improved later...
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
