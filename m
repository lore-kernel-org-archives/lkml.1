Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbYKQDF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbYKQDF1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 22:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbYKQDFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 22:05:10 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:1709 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbYKQDFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 22:05:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=nLb1jK6qbiWN7vvIHumYmGt4m7kBwD7rp7XbBNkTyIP6sMeWDdUoNKoTkoFrf47C4c
         /wUeiZWjwK1axmIx1tTN7ITNINJmdXUTXHZqJgeDBTQaH807klat1AUYbbvOpzcvH7BU
         HkeZhAM4bu9yS5QyxEdkkFQE/GjM/+vL3OFQM=
Message-ID: <4920DF5C.3030400@gmail.com>
Date: Mon, 17 Nov 2008 12:05:00 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Gerold Jury <gml@inode.at>, efault@gmx.de, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       vsu@altlinux.ru
Subject: Re: extra bytes written to SATA DVD drive on kernel 2.6.23 till 2.6.24.2
References: <200802252005.22663.gml@inode.at> <200803011329.11315.gml@inode.at> <47D0FF67.8050503@gmail.com> <47D0FF67.8050503@gmail.com> <200803072009.22551.gml@inode.at> <E1JXic1-0000Yo-K8@faramir.fjphome.nl>
In-Reply-To: <E1JXic1-0000Yo-K8@faramir.fjphome.nl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> Gerold Jury wrote:
>> 0001ffe0  e0 ff e1 ff e2 ff e3 ff  e4 ff e5 ff e6 ff e7 ff  |................|
>> 0001fff0  e8 ff e9 ff ea ff eb ff  ec ff ed ff ee ff ef ff  |................|
>> 00020000  2a 00 00 00 00 40 00 00  40 00 00 00 00 40 00 00  |*....@..@....@..|
> 
> Looks broken here too.
> 
>> 00020010  08 ff 09 ff 0a ff 0b ff  08 ff 09 ff 0a ff 0b ff  |................|
>> 00020020  00 00 01 00 02 00 03 00  04 00 05 00 06 00 07 00  |................|
> 
> It also seems like part gets repeated after the break in both cases.

Can you guys please add yourselves to bz#10743?

  http://bugzilla.kernel.org/show_bug.cgi?id=10743

Please test 2.6.28-rc5 as it contains sata_via changes (TF access needed
specific workaround) and see whether the problem is fixed and report on bz.

Thanks a lot.  Let's get this thing solved.

-- 
tejun
