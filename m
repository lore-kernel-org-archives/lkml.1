Return-Path: <linux-kernel-owner+w=401wt.eu-S935516AbXGMIOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935516AbXGMIOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 04:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760257AbXGMIOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 04:14:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:39567 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948AbXGMIOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 04:14:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=adtDAGMiKg+sTJg/RsKlmuVgA7OmDHUo2aMAFhkqO3ImJ9gkdGODk52lMe5B28D258gfL8/digb2/p9gCfSK/QMDzQ7ZueROaCqJnmlxJ/QirJYuZm+f9dXP7xa1wa9ed8CrN3gGj320TerpwB61dbZSe3E6y98QcAfx7PO8RRs=
Message-ID: <46973444.6090707@gmail.com>
Date: Fri, 13 Jul 2007 17:13:56 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: david@aeolia.co.uk
CC: Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org
Subject: Re: Hard drive - dead or dying?
References: <1184222444.5969.0.camel@ceres>  <46962E09.40606@rtr.ca> <1184272299.5965.4.camel@ceres>
In-Reply-To: <1184272299.5965.4.camel@ceres>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Sumbler wrote:
> On Thu, 2007-07-12 at 09:35 -0400, Mark Lord wrote:
>> David Sumbler wrote:
>>> My computer (Ubuntu Feisty) would not boot correctly a few days
>>> ago: it seemed to get into a loop with the following printed about
>>> every 7 seconds (all laboriously copied in longhand, since it wasn't
>>> logged!):
>>>
>>> ata1.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
>>> ata1.01: (BMDMA stat 0x65)
>>> ata1.01: cmd c8/00:08:80:b4:a8/00:00:00:00:00/f4 tag0 cdb 0x0 data 4096
>>> in
>>>          res 51/01:08:80:b4:a8/00:00:00:00:00/f4 Emark 0x1 (device error)
>> Use 'smartctl' to find out what the drive is having issues with.
> 
> Unfortunately I cannot boot the computer unless the drive in question is
> disconnected.

Hmm... it might take some time but you should be able to.  Just don't
mount it during boot.  Partition code would still try to read partition
table which can cause some number of errors but it will eventually give
up and let you continue.

-- 
tejun
