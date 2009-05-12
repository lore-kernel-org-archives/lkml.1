Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbZELRiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbZELRiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 13:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbZELRh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 13:37:58 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:19375 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbZELRh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 13:37:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=crj2Z0XOx9gq3FVh4SmMEhFVTeo5URxMyjqsqVXZG/ivHA9XxhvFt9FdB36NlpaZvb
         Tm7MH/t7vagExRwQqJzqK48kuPv9iNuJUrcMUn4kf9snyOMtU6Yn/hg2yaTTPY/OlLfG
         XeImzhY2EtErYlK0gpuOcnZhajNdEp27mpeZQ=
MIME-Version: 1.0
In-Reply-To: <20090512164448.GJ16247@kroah.com>
References: <1242127393-4298-1-git-send-email-a.beregalov@gmail.com>
	 <20090512164448.GJ16247@kroah.com>
Date: Tue, 12 May 2009 21:37:56 +0400
Message-ID: <a4423d670905121037i3ea96b01s68367c082802684d@mail.gmail.com>
Subject: Re: [PATCH] Staging: agnx: switch config_interface to 
	bss_info_changed
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, johannes@sipsolutions.net, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/12 Greg KH <greg@kroah.com>:
> On Tue, May 12, 2009 at 03:23:13PM +0400, Alexander Beregalov wrote:
>> Fix this build error:
>> drivers/staging/agnx/pci.c: In function 'agnx_config_interface':
>> drivers/staging/agnx/pci.c:315: error: dereferencing pointer to incomplete type
>> ..
>> drivers/staging/agnx/pci.c:424: error: unknown field 'config_interface' specified in initializer
>>
>> config_interface was removed in 2d0ddec5b2b
>> ("mac80211: unify config_interface and bss_info_changed")
>
> I do not see that patch in Linus's tree.  Is it in some other tree
> (wireless?) and not yet in mainline?
Yes, it is in wireless from linux-next.
You asked to send patches based on linux-next, right?
Should I always mark patches for staging-next tree as [PATCH -next] ?
