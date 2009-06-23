Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbZFWRmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbZFWRmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbZFWRmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:42:40 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:59371 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbZFWRmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:42:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Nf/7gYGkhkPLpmIeFLlghsV5ctwk7JND2RBpZDQLC5Q8p9yjlWjIOVdGkUnxd6LGuD
         4K8xtR4GoCI0PTr0+rsS0XlbJJ1zVlwKcn3Aia5O3jno+llcUlS94JCnYkYKZ4fy3uVO
         +hO5a22SLdelELXjCB3V5RK6jpHBi40kKcrjk=
Message-ID: <4A411319.4020108@gmail.com>
Date: Tue, 23 Jun 2009 19:38:33 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Tim Bird <tim.bird@am.sony.com>, Chris Simmonds <chris@2net.co.uk>,
       Arnd Bergmann <arnd@arndb.de>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/14] Pramfs: Include files
References: <4A33A7EC.6070008@gmail.com> <200906221317.04166.arnd@arndb.de> <4A3FC7F1.5050108@gmail.com> <200906222033.20883.arnd@arndb.de> <4A3FDBFE.8050509@2net.co.uk> <20090622203034.GA12587@uranus.ravnborg.org> <4A3FFF17.9020701@am.sony.com> <20090623042106.GA17159@uranus.ravnborg.org>
In-Reply-To: <20090623042106.GA17159@uranus.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>>> It should be possible to read a file-system on your x86 64bit
>>> box that you wrote with your small powerpc target.
>> For a (NV)RAM-based filesystem??  WTH???
> 
> dd the full image - dig into it.
> Usefull is you have post-mortem info there.
> 
> 	Sam
> 

dd? You haven't got any device file to have a dump. I think we're going
a bit out of scope. I had some doubt to support rootfs in pram and after
some feedback and the comments of this review I think I'll remove it
from the next release (to understand some aspects of this fs with the
kernel community was my main goal for this review). I agree to use the
native endian. As I said the important thing is that if an user want to
use it in a 64bit environment then the fs must work well and then it
must be designed to support even this situation, I think it's obvious.

Marco

