Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbYKNIAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbYKNIAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 03:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYKNIAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 03:00:23 -0500
Received: from smtp.nokia.com ([192.100.122.230]:26361 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYKNIAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 03:00:22 -0500
Message-ID: <491D2F09.3070104@yandex.ru>
Date: Fri, 14 Nov 2008 09:55:53 +0200
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: linux-kernel@vger.kernel.org, sct@redhat.com, akpm@linux-foundation.org,
       adilger@sun.com, tytso@mit.edu, linux-ext4@vger.kernel.org,
       dedekind@infradead.org, ext-adrian.hunter@nokia.com,
       linux-mtd@lists.infradead.org, dushistov@mail.ru, jmorris@namei.org
Subject: Re: [PATCH] filesystems: use has_capability_noaudit interface for
 reserved blocks checks
References: <1226430769.3353.5.camel@localhost.localdomain>
In-Reply-To: <1226430769.3353.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 14 Nov 2008 07:57:35.0146 (UTC) FILETIME=[A79F88A0:01C9462E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> ext[2,3,4], ufs, and ubifs all check for  CAP_SYS_RESOURCE to determine
> if they should allow reserved blocks to be used.  A process not having
> this capability is not failing some security decision and should not be
> audited.  Thus move to using has_capability_noaudit.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> ---

UBIFS part looks OK, as long as the whole idea of the patch is right, which
I have not checked, but assume it is.

The only question is are you sure exporting 'cap_capable()' is relevant
to this patch? You do not seem to call it directly.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
