Return-Path: <linux-kernel-owner+w=401wt.eu-S1759840AbZKLBKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759840AbZKLBKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 20:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759718AbZKLBKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 20:10:25 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:39321 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535AbZKLBKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 20:10:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OnSG4oFByUXUe26dGsghNORnunKF/IyyOMQ2orzWaTzbeud2iYqs4kL8Wz6FSPiGbH
         5o+dvmWo5rIND+RDyTaEtWnDf09wCpUASYjGkLGk2OLjUPjxRPsyd43v3TDwCkiDwTwn
         or4fsPPAt2GDgOk6Io3EXMvn4FvtQwN39c2Es=
MIME-Version: 1.0
In-Reply-To: <20091111235808.GQ24837@atomide.com>
References: <1252874472-21089-1-git-send-email-felipe.contreras@gmail.com>
	 <20091111235808.GQ24837@atomide.com>
Date: Thu, 12 Nov 2009 03:10:30 +0200
Message-ID: <94a0d4530911111710p67d1de65obc328b120a549f00@mail.gmail.com>
Subject: Re: [PATCH v2] omap3-iommu: reorganize
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 1:58 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Felipe Contreras <felipe.contreras@gmail.com> [090913 13:41]:
>> This way it's more object oriented and easier to see what is happening.
>> No functional changes.
>
> Felipe, can you please refresh this against omap for-next branch?

I just tried and it doesn't require any changes.

Just do this and it will apply cleanly (not really part of the patch):
- #include <mach/iommu.h>
+ #include <plat/iommu.h>

-- 
Felipe Contreras
