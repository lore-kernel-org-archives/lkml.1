Return-Path: <linux-kernel-owner+w=401wt.eu-S934548AbXGTVA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934548AbXGTVA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755623AbXGTVAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:00:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:64004 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761335AbXGTVAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:00:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ebRJuQ0ez2RlZumVDkUnBwTX5lilXLqs52K7G20aR197AunK5szhf8EbZjESVZ7VoEsbh8084WCAz0Bgx1vXZGRyOaNmUdAwIt358B7imjt4Ouqy7+J/Wgq5ff4NBMYfsflGpYVpuVy/dgJzZ0TyC6wAkTq3s/7DpUu2+4plblY=
Message-ID: <46A121DD.2090304@googlemail.com>
Date: Fri, 20 Jul 2007 22:58:05 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-git13 crash
References: <46A11E4B.3070002@tmr.com>
In-Reply-To: <46A11E4B.3070002@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> built from 2.6.22-git9 config, used oldconfig. Crashes so early it 
> doesn't seem to get to the network card.
> 
>   config: www.tmr.com/~davidsen/config-2.6.22-git13.gz
>   screen dump: www.tmr.com/~davidsen/dump-2.6.22-git13.jpg
> 
> Not much info, and probably seen elsewhere.
> 

Should be fixed by this commit :

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9550b105b8646f916862aee3ab7b25020ca14159


Regards,

Gabriel C
