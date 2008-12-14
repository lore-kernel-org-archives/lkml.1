Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbYLNTXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbYLNTXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 14:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbYLNTXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 14:23:47 -0500
Received: from cantor.suse.de ([195.135.220.2]:49450 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbYLNTXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 14:23:47 -0500
Message-ID: <49455ED2.1010909@suse.de>
Date: Mon, 15 Dec 2008 03:30:26 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avoid unnecessary assignment in lookup_bdev()
References: <49455170.6080307@suse.de> <20081214191233.GB31396@kroah.com>
In-Reply-To: <20081214191233.GB31396@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Greg KH Wrote:
> On Mon, Dec 15, 2008 at 02:33:20AM +0800, Coly Li wrote:
>> In normal cases, lookup_bdev() should return successfully, therefore it's not a good idea to always
>> assign error values before checking truth/false conditions. This patch modifies code to only assign
>> error value in necessary false conditions.
>>
>> If I missed something, please correct me.
> 
> I don't understand, is there some way that the current code could
> incorrectly return an error value?
> 
> Is your change somehow faster?  I don't think this is on any fast-path
> code, right?
For 1 or 2 lines to set error value before checking condition, that's a clean coding style. But for
more places in one function to set error value this way, I can't say that's perfect.

lookup_bdev() is just in my code review stack, the way to set error value just makes me
uncomfortable. Maybe it is because my threshold (>=3) is lower than others. This patch can not bring
up any *real* faster, but sending it out makes me feel better at least :)

-- 
Coly Li
SuSE PRC Labs
