Return-Path: <linux-kernel-owner+w=401wt.eu-S1759363AbZEZXtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363AbZEZXtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbZEZXtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:49:15 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:62015 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbZEZXtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:49:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NGL2zs6GqcZL+EyMa93Kau9BWByQXllmiwKVQK5yYFi8P5QWG4Ef/eBVfTao9kwY5R
         VlgXATkNVuNqkbLI9hir0y7mYmm9LfyKr8tbe/Y5jupc8tRZJYBimkbMipF5tT6PtHBN
         0dG0IMd/T/4olpL1r9DyG50zhthG8eMHdVUfs=
Message-ID: <4A1C7FF5.4060205@gmail.com>
Date: Tue, 26 May 2009 17:49:09 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ide: add "ignore_hpa" module parameter
References: <200905252344.11826.bzolnier@gmail.com> <200905260106.13705.elendil@planet.nl> <200905261423.40117.bzolnier@gmail.com> <200905261453.22428.elendil@planet.nl>
In-Reply-To: <200905261453.22428.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
>> Moreover the (much needed) work from Tejun doesn't help a tiny bit in
>> case of people migrating their *working* setups from IDE to libata
> 
> From what I've seen now that seems the most important case that needs 
> supporting, as well as the case where a working setup would migrate from 
> IDE with old HPA default to IDE with new HPA default.
> 
> Naive thought: wouldn't it be possible to check whether a partition 
> overlaps the HPA boundary and warn or even bug out in that case?

It does, you get a warning about the partition exceeding device 
capacity. Easy to miss that, however.
