Return-Path: <linux-kernel-owner+w=401wt.eu-S933518AbXGWTLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518AbXGWTLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762099AbXGWTLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:11:46 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:43018
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760401AbXGWTLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:11:45 -0400
Date: Mon, 23 Jul 2007 12:08:08 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Oliver Neukum <oliver@neukum.org>
cc: Miklos Szeredi <miklos@szeredi.hu>, rjw@sisk.pl, nigel@nigel.suspend2.net,
       stern@rowland.harvard.edu, nigel@suspend2.net, jbms@cmu.edu,
       miltonm@bga.com, ying.huang@intel.com, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <200707231431.30372.oliver@neukum.org>
Message-ID: <Pine.LNX.4.64.0707231205500.3828@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707221116060.15224-100000@netrider.rowland.org>
 <200707231408.32051.rjw@sisk.pl> <E1ICwoE-0004q8-00@dorka.pomaz.szeredi.hu>
 <200707231431.30372.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-1671903907-1185217688=:3828"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-1671903907-1185217688=:3828
Content-Type: TEXT/PLAIN; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 23 Jul 2007, Oliver Neukum wrote:

> Am Montag 23 Juli 2007 schrieb Miklos Szeredi:
>>> The reason is that we want them to "park" in safe places, ie. where there
>>> are no locks held etc.  Thus, these safe places need to be chosen somehow
>>> and since they are not marked throughout the code, we choose the obvious
>>> one. :-)
>>
>> Why shouldn't locks be held?
>>
>> No locks which are required for suspend must be held, sure.  But
>> otherwise holding locks doesn't matter at all.
>
> If you can provide a way to tell them apart, this would work.

can you just tell the driver to try and suspend and if it reports back 
that it fails back out of the suspend? or will the driver deadlock instead 
of reporting a failure if a lock is held.

David Lang
--680960-1671903907-1185217688=:3828--
