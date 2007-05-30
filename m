Return-Path: <linux-kernel-owner+w=401wt.eu-S1757836AbXE3XP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbXE3XP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbXE3XPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:15:50 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:56427 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbXE3XPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:15:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d6J7yF2gjSEHhsqYFEajvkCMPtbc42/RyryrLOteF83XjEXQiM4fWiOa/foAeC49pFigY8NAn2Xux/AA504UQdzFopne/wUI6WLBLP9YLeVZIlpY7wyD1L8Au4pxAa7Fk+UmYo9tHyiFouq1D8h4haEVlL5rlJWqn7mkn/vsCzI=
Message-ID: <9a8748490705301615y73a11fcfn5fc7a88bf6eef2b1@mail.gmail.com>
Date: Thu, 31 May 2007 01:15:47 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Reinaldo Carvalho" <reinaldow@gmail.com>
Subject: Re: megaraid.c, all kernel versions, problem with multi-luns
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <ec36785a0705301609t62676c76q3a2b726bf51d50db@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ec36785a0705301609t62676c76q3a2b726bf51d50db@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/05/07, Reinaldo Carvalho <reinaldow@gmail.com> wrote:
> Hi,
>
> I have a Dell PowerEdge Expandable RAID controller, with a hardware
> Raid-5 at Channel 01 running perfectly, and a nCipher Crypter at
> Channel 02.
>
> This controller doesn't correctly detect devices (e.g. nCipher
> Crypter) with multiples LUNs. Only one LUN is detected.
>
> At another controller (e.g. Adaptec 79xx) two LUNs were detect. I
> compiled 2.6.8, 2.6.18 and 2.6.21.3 to test megaraid driver and all
> failed detecting two LUNs.
>

Did you build your kernel with CONFIG_SCSI_MULTI_LUN enabled?  This
option will force the SCSI driver to probe for multiple LUN's.
Without this option only one LUN may be detected, and since that's the
common case (devices only having one LUN) people often forget about
this option :)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
