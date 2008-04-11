Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbYDKCIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbYDKCIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 22:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYDKCIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 22:08:43 -0400
Received: from po-out-1718.google.com ([72.14.252.155]:63070 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYDKCIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 22:08:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=daAEVGOGlSDstJgA/1TMzoKWPvvMNtgfjRjXdxBKL1/CbHRf5ZcBAzK/SfjEcxtgFICBCPNwrs5ZzYndZXkT0iulLP35Kqj8Zp3YoMn41LtD4TbCkR3CNkywHJ8D0k3qbSAxr2sWOoBzzjrUWx/i+dIn/Cky0VMUSTk+vL+KSXo=
Message-ID: <47FEC823.9000100@gmail.com>
Date: Fri, 11 Apr 2008 11:08:35 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       jgarzik@pobox.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 6/13] devres: implement managed iomap interface
References: <11684073371547-git-send-email-htejun@gmail.com>	<47FA4FD2.8060808@ru.mvista.com> <47FB85CB.2070506@gmail.com> <47FB8751.3040301@ru.mvista.com> <47FE46AC.5000901@ru.mvista.com> <59A939C7-75AF-4C0F-8199-4C31D174AEA9@kernel.crashing.org> <47FE5B76.40409@ru.mvista.com> <A567023C-17FC-402D-9394-29DFFA816891@kernel.crashing.org>
In-Reply-To: <A567023C-17FC-402D-9394-29DFFA816891@kernel.crashing.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
>>> but there is no reason not to make it work properly.  For example I  
>>> believe libata uses devm_* and the fsl SATA driver (non-PCI) will 
>>> need  to work in cases similar to the 44x.
>>
>>   Well, as for sata_fsl, it calls of_iomap() which does The Right Thing.
> 
> Fair, but I don't see why we should introduce new APIs that are already 
> "broken".  We went through a lot of effort to clean up and introduce 
> resource_t (and clearly still have some bugs) for the >32-bit physical 
> address problem.

Yes, please go ahead.  In case it wasn't clear, I wasn't objecting to 
the fix at all.  I was just curious what could actually happen on x86.

-- 
tejun
