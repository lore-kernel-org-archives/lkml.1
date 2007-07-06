Return-Path: <linux-kernel-owner+w=401wt.eu-S1762061AbXGFBxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762061AbXGFBxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 21:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761173AbXGFBw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 21:52:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:58532 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759597AbXGFBw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 21:52:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=e5CksJfgJx6Dt0+5N8t3jmz/uliLVfcyYKF2kiXIHFRm8dNwoM7L06jEwRAuKA+tyFyCO5ktTziKLNPel4NFw8izmU8R6IEFJTjGt/LfT47AHxCeIOEmCZFEGMfBRXyiwZc/kgVPmyThCA4V5ozAy+EgscV2yrCdx6uPThGOPLA=
Message-ID: <468DA071.9010605@gmail.com>
Date: Fri, 06 Jul 2007 10:52:49 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: caglar@pardus.org.tr
CC: LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: SATA exceptions
References: <200707060046.13237.caglar@pardus.org.tr>
In-Reply-To: <200707060046.13237.caglar@pardus.org.tr>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

S.Çağlar Onur wrote:
> [ 4260.278427] ata1.00: cmd ca/00:08:d0:88:bc/00:00:00:00:00/ee tag 0 cdb 0x0 
> data 4096 out
> [ 4260.278430]          res 51/40:01:d7:88:bc/00:00:0e:00:00/ee Emask 0x9 
> (media error)

That's media error on sector 247236823 on WRITE.  Media errors on write
are bad signs - it usually means the drive even failed to remap the
sector because extra space ran out.  I'm not sure this is the case here
tho - the smart log is clear.  Please run smart short/long tests and see
what they say.

-- 
tejun
