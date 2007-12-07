Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbXLHAAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbXLHAAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 19:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXLGX7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 18:59:55 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:56153 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbXLGX7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 18:59:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=uwHb+xnDOAtstyAwMbj9hcIaY0G29e3wlRARaWDp0jFvZuROt0rU23VplZIFgK9RoRsoMOc91JBlcRGKlAIOMsZvboLyOKQQpPcV0PsdI5X4/KlDBhaMxvZXxDAiUssF5ogpHFvJWN5l+mT/ToxM5Dwlr37tsXQyujenPC4yBQk=
Message-ID: <4759DE63.7010206@gmail.com>
Date: Sat, 08 Dec 2007 08:59:31 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: sam@ravnborg.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       notting@redhat.com, rusty@rustcorp.com.au, kay.sievers@vrfy.org,
       greg@kroah.com
Subject: Re: [PATCH] kbuild: implement modules.order
References: <47555AF1.8090304@gmail.com> <20071207174843.GA20441@stusta.de>
In-Reply-To: <20071207174843.GA20441@stusta.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Tue, Dec 04, 2007 at 10:49:37PM +0900, Tejun Heo wrote:
>> When multiple built-in modules (especially drivers) provide the same
>> capability, they're prioritized by link order specified by the order
>> listed in Makefile.  This implicit ordering is lost for loadable
>> modules.
>> ...
> 
> What exactly are the drivers you are thinking of?
> 
> I would rather see us getting away from any link order dependencies.
> 
> E.g. we might one day want to compile the whole kernel with one gcc call 
> (using "--combine -fwhole-program").

The following bugzilla triggered this change and I think contains enough
discussion on the subject.

  http://bugzilla.kernel.org/show_bug.cgi?id=8933

Thanks.

-- 
tejun
