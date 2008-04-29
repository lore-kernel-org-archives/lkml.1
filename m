Return-Path: <linux-kernel-owner+w=401wt.eu-S1757719AbYD2U1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719AbYD2U1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758425AbYD2U1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:27:10 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:24252 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757694AbYD2U1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:27:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=cc:message-id:to:in-reply-to:content-type:content-transfer-encoding:mime-version:subject:date:references:x-mailer:from;
        b=SOvUigd/CB+x45+MVOc4gYMZsbG1+OGeGXJanfxi4bE0vDXTlkVF1YevysOgy24fdOOSgycRoTxUeKJqgVIHlFCN9c9idxGAsvYMqsY5h0x9AvWdH+ax1m3O0JGOSOYWQ6I2Fwl0TByEVvaYxIgRzic4M5e/7Xp8hUTUxrFvXuY=
Cc: Timur Tabi <timur@freescale.com>,
       Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>,
       linux-kernel@vger.kernel.org
Message-Id: <F963C774-E80A-48C6-AC86-681232CEE6CF@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <20080429164501.GA18018@uranus.ravnborg.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: Why use /bin/sh in kernel build system?
Date: Tue, 29 Apr 2008 15:27:02 -0500
References: <481529B6.6030802@freescale.com> <8FEAC32C-868F-468C-B383-8450D400691C@e18.physik.tu-muenchen.de> <48173607.6080307@freescale.com> <20080429164501.GA18018@uranus.ravnborg.org>
X-Mailer: Apple Mail (2.919.2)
From: Mark Rustad <mrustad@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 29, 2008, at 11:45 AM, Sam Ravnborg wrote:

>> I read in the latest Linux Journal magazine that someone noticed  
>> that even
>> though the kernel scripts say #!/bin/sh, many of them are really  
>> bash scripts.
>> This person went through the effort of changing the script to be  
>> true 'sh'
>> scripts.  Has that code been merged in?
>
> I have no patches pending but I may have lost them.
> As I am 100% ignorant about what is bash and what is not bash  
> specialities
> I will more or less be blind when I apply them so I hope they are well
> tested.


So why use /bin/sh ever in the kernel build system? I consciously  
began using /bin/bash consistently in scripts years ago because you  
just never know what you get when you use /bin/sh. I remember  
replacing /bin/sh with /bin/bash in gcc's build system to get it to  
work on some system at some point. Life is too short to keep having to  
fight silliness like this and I can't see a valid reason why a system  
building a Linux kernel, or for that matter gcc, should not have the  
bash shell installed on it.

And on some systems, changing /bin/sh to point to /bin/bash can result  
in subtle problems with that system's environment, so that is not a  
good option. At least by using /bin/bash you know what you get and the  
dependency is then known to all.

-- 
Mark Rustad, MRustad@gmail.com


