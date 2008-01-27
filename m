Return-Path: <linux-kernel-owner+w=401wt.eu-S1755803AbYA0CQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbYA0CQw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 21:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYA0CQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 21:16:44 -0500
Received: from qb-out-0506.google.com ([72.14.204.227]:60985 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbYA0CQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 21:16:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=UYmf2ptOUL3oLWxA1WgXGDDupPYiM6vapnEDU+xXl7npWVrxAD22xuzj5zO7OkxBH5thph3EWJEQXJKQZ885UFqpFbVdbKQOwmFEBLSkxTqMCdYklvVZnBVeUGRaaKUULcAJRDGWLSSMeJXwp/pTTQb+iLcZjuF67sNWCuZq9SI=
Date: Sun, 27 Jan 2008 10:14:29 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: The latest linus tree can't build
Message-ID: <20080127021429.GA2495@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080126103845.GF20935@hacking> <20080126104514.GA18170@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080126104514.GA18170@does.not.exist>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 12:45:14PM +0200, Adrian Bunk wrote:
>On Sat, Jan 26, 2008 at 06:38:45PM +0800, WANG Cong wrote:
>> 
>> Hi, Sam!
>> 
>> When I built the latest linus tree, I got this error:
>> 
>> ...
>>   CC      sound/oss/msnd.o
>> make[2]: *** No rule to make target `/etc/sound/msndperm.bin', needed by `sound/oss/msndperm.c'.  Stop.
>> make[1]: *** [sound/oss] Error 2
>> make: *** [sound] Error 2
>> 
>> My .config is just the one I sent to you in another thread.
>>...
>
>It's expected that CONFIG_STANDALONE=n allows configurations that won't 
>compile.

Oh, thank you!

