Return-Path: <linux-kernel-owner+w=401wt.eu-S1757729AbYDHPDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbYDHPDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 11:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbYDHPDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 11:03:45 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:2891 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbYDHPDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:03:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=amyrmzE5cQrkbOl1XQ2f4An2VMWiygUKpNZFCGWha/SswprEAP5zOrgCo6rcPGOj09XVMCnWWDSLOIuTrMu9ox6rBcjfESDsrVi7m3LEg7i/vaY3BEXnY3XpUheGPZfrN8S5QUtnqWIzzRKbmO5/eTPN62w2DjO6EXkY1MfkcqY=
Message-ID: <47FB8948.9090302@gmail.com>
Date: Wed, 09 Apr 2008 00:03:36 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: jgarzik@pobox.com, gregkh@suse.de, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 6/13] devres: implement managed iomap interface
References: <11684073371547-git-send-email-htejun@gmail.com> <47FA4FD2.8060808@ru.mvista.com> <47FB85CB.2070506@gmail.com> <47FB8751.3040301@ru.mvista.com>
In-Reply-To: <47FB8751.3040301@ru.mvista.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
>> Yeah, right please go ahead.  But I wonder whether any BIOS was 
>> actually crazy enough to map mmio region above 4G on 32bit machine.
> 
>    This is a *hardware* mapping on some non-x86 platforms (like PPC 44x 
> or MIPS Alchemy). The arch/ppc/ and arch/mips/ kernels have special 
> hooks called from ioremap() which help create an illusion that the PCI 
> memory space on such platforms (not only it) is mapped below 4 GB; 
> arch/powerpc/ kernel doesn't do this anymore -- hence this newly 
> encountered issue.

Ah... I see.  Thanks for the clarification.

-- 
tejun
