Return-Path: <linux-kernel-owner+w=401wt.eu-S1755626AbYKKKNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbYKKKNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 05:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbYKKKNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 05:13:08 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:35943 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396AbYKKKNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 05:13:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nbw12HPRD4Z9mp/e1Hz5gmsOm9UXLGo7s1rmWD2v9aIHbI1HZXpP3Z6AhV5Cp/Tu0W
         6zhww3WNFIaMl3V7k5/7y1yhg9DYLhz80VUEGK9Qb4aAgSF8Ce6QoC28m3Y/HITXQ1lc
         NFlbdRQlH0/v2PLHlzGnIt6d/R7R1HcyEfeDs=
Date: Tue, 11 Nov 2008 13:16:29 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: CIJOML <cijoml@volny.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Possibility to build more kernels in one shot?
Message-ID: <20081111101629.GA3665@x200.localdomain>
References: <200811110801.14206.cijoml@volny.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811110801.14206.cijoml@volny.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 08:01:14AM +0100, CIJOML wrote:
> currently I compile kernel for 12 different machines. I would like to see 
> profile support in kernel, so I could have all my .configs in source and 
> compile them in one shot. and than see in profile directory subdirectories 
> for every config with it's vmlinuz and modules.

Write a script, shouldn't take more than 15 min including testing.
And use "make O=".

> I think it would speedup also compilation time because some .o should be than 
> reuse.

Very optimistic hope. Use ccache(1) if you want .o reuse.
