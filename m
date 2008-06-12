Return-Path: <linux-kernel-owner+w=401wt.eu-S1758342AbYFLUfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbYFLUfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 16:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbYFLUfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 16:35:47 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:59255 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbYFLUfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 16:35:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=kJyWqONyQYQix/UQ3sfunZdw6mVHATDHfLyGnFX875I7qHbolat+tsQctE5XUsb0lx
         DHwXCezkm/5t+AN4tAc0e3BQbDEY5xP5HFSOvesV7RJ0weDg/N/KOIVxWdW/FE0G/6yZ
         LpE5w2ujttpm29n/xo6jovioFt+z7Z2qwmB/A=
Message-ID: <e9e943910806121335g4bd858bga91e2d336f5b9760@mail.gmail.com>
Date: Thu, 12 Jun 2008 21:35:25 +0100
From: "Duane Griffin" <duaneg@dghda.com>
To: "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/6] ext4: tighten restrictions on inode flags
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       akpm@linux-foundation.org, "Andreas Dilger" <adilger@sun.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1213298827.6382.2.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213142649-32685-1-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-2-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-3-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-4-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-5-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-6-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-7-git-send-email-duaneg@dghda.com>
	 <20080611113104.GC9008@skywalker>
	 <e9e943910806110449sbf30bf6xd98840fcd343519d@mail.gmail.com>
	 <1213298827.6382.2.camel@norville.austin.ibm.com>
X-Google-Sender-Auth: d09a260f5f621f51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/12 Dave Kleikamp <shaggy@linux.vnet.ibm.com>:
>> Whoops, I was matching the fields in ex4_inode, but I should have been
>> looking at ext4_inode_info. Shouldn't sparse have complained about
>> that?
>
> It does, but not by default.  You need to run sparse with
> -D__CHECK_ENDIAN__
>
> I use this alias:
> make_sparse is aliased to `make C=2 CF="-D__CHECK_ENDIAN__"'

That does the trick nicely, thanks!

> Shaggy

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
