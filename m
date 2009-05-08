Return-Path: <linux-kernel-owner+w=401wt.eu-S1758208AbZEHXg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbZEHXg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 19:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbZEHXgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 19:36:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:48373 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbZEHXgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 19:36:11 -0400
Message-ID: <4A04C1A8.2070904@kernel.org>
Date: Sat, 09 May 2009 08:35:04 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net
Subject: Re: [PATCHSET] CUSE: implement CUSE, take #3
References: <1239674094-30894-1-git-send-email-tj@kernel.org> <E1Lwanr-00041r-RP@pomaz-ex.szeredi.hu> <49EFB1A9.3060503@kernel.org> <E1LwvrC-00068P-5r@pomaz-ex.szeredi.hu> <49F043A4.2060700@kernel.org> <E1LypSa-0004fR-J1@pomaz-ex.szeredi.hu> <49F908A1.70207@kernel.org> <49F90941.2030405@kernel.org> <E1M1dVf-00051D-JE@pomaz-ex.szeredi.hu>
In-Reply-To: <E1M1dVf-00051D-JE@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 23:35:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> On Thu, 30 Apr 2009, Tejun Heo wrote:
>> Tejun Heo wrote:
>>>> I'll post the updated libfuse patch as well.  Please let me know if
>>>> you find anything wrong with the current patches.
>>> Looks good to me.  Much prettier with two inits merged.
>> Oh... what happened to CUSE_INIT_DONE?
> 
> By moving the CUSE_INIT reply processing into the ->end() callback,
> the device initialization becomes synchronous with the process writing
> the message into the cuse device.
> 
> This means, that the process can simply wait for the write() on the
> device to complete before proceeding.
> 
> I've updated the libfuse patch so it calls ->init_done() after sending
> the CUSE_INIT reply.

Ah... cool.  Thanks.

-- 
tejun
