Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab0CJABU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 19:01:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:48335 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab0CJABP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 19:01:15 -0500
Message-ID: <4B96E136.3030001@kernel.org>
Date: Wed, 10 Mar 2010 09:00:54 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       tytso@mit.edu, "H. Peter Anvin" <hpa@zytor.com>,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <4B965348.3050201@teksavvy.com>
In-Reply-To: <4B965348.3050201@teksavvy.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 00:00:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2010 10:55 PM, Mark Lord wrote:
> On 03/07/10 22:48, Tejun Heo wrote:
> ..
>> Please note that hdparm is misreporting the alignment offset.  It
>> should be reporting 512 instead of 256 for offset-by-one drives.
> ..
> 
> That issue was fixed quite a while ago.
> Upgrade your elderly copy of hdparm.

Heh heh, *you* were keeping it from me!  Anyways, is there hdparm
devel tree published somewhere?  I wandared the SF page for quite a
bit (which for some reason is very difficult to find things in) but I
couldn't find one.  If it's not, it might be a good idea to put it on
SF or git.kernel.org?

Thanks.

-- 
tejun
