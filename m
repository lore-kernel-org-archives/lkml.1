Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbYHCN7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbYHCN7R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 09:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755297AbYHCN7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 09:59:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:44997 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbYHCN67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 09:58:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=gvu9noqZrdx8Xxj24EmYfwIVQFY8bGKFEvi2S+b4oCrdwzhAutlhEaUyfH25RRvGyx
         KFxmaAyarRknugnn+g3fl0WqCCD+g0lTZAsAdzypifkCRaChjNzhYlH8Igvxaq/1ER8X
         v9AjDuT2q0r1UKkyElaRgSG4lmzgaSiE8uO5A=
Message-ID: <4895B97F.4020708@gmail.com>
Date: Sun, 03 Aug 2008 22:58:23 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Elias Oltmanns <eo@nebensachen.de>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] libata: Implement disk shock protection support
References: <87prp1kvyy.fsf@denkblock.local>	<20080726062142.29070.10413.stgit@denkblock.local>	<4892B8FE.1070400@gmail.com>	<20080801233459.11e9b254@lxorguk.ukuu.org.uk>	<489523DC.2090903@gmail.com> <20080803140536.062c2ef1@lxorguk.ukuu.org.uk>
In-Reply-To: <20080803140536.062c2ef1@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> on both sides of the cable and I think things like that would be more
>> difficult to work accidentally.
> 
> We'd have to query the drive vendors to see what they expected.

We'll have to query the controller vendors too and I think it's highly
likely to cause problems on many controllers.

-- 
tejun
