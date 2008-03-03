Return-Path: <linux-kernel-owner+w=401wt.eu-S1760485AbYCCRkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760485AbYCCRkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756224AbYCCRfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:35:41 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:41157 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556AbYCCRfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:35:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GI4jP/lnDxNbh265uruvykJ389nBOxpyENU/pcURMcJEPZxlTtq3mmE6jsBgYd029opZcSSpj7/Ufgw4N6UHvPwV8Z7ZENsVRkEXn2iiCxjSP5/xiONeRmraMkPX4x0LQvadWh9Ik0NkWhs3Aj3UWf67cdOqIUdND3s+3nhs2HQ=
Message-ID: <5d6222a80803030935x69fa6e3cv2c6d3afdf9017b98@mail.gmail.com>
Date: Mon, 3 Mar 2008 14:35:36 -0300
From: "Glauber Costa" <glommer@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 0/52] First attempt at smp integration
Cc: "Glauber Costa" <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <20080303172215.GA7918@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
	 <20080303172215.GA7918@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 2:22 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Glauber Costa <gcosta@redhat.com> wrote:
>
>  > Hi,
>  >
>  > This series of patches does a first attempt at smp integration (I call
>  > it first, although I don't believe it's too far away from a real one).
>  > The series comprises 52 patches, and the full diffstat says in the
>  > end:
>  >
>  >        34 files changed, 1858 insertions(+), 2344 deletions(-)
>  >
>  > smp_32.c and smp_64.c are completely gone. smp.h and smpboot_{32,64}.c
>  > are not, although substantially reduced. I know that ideally, no
>  > leftovers are wanted, but the series were already big enough (I tried
>  > to split the patches as much as I could), so I considered this a good
>  > cutting point. If this is all agreed upon and merged, I'll start
>  > looking at the other bits that are left.
>  >
>  > All patches are tested is various random x86 subarchitectures, and all
>  > of them works. The result also boots fine in mine x86_64 and i386
>  > boxes.
>
>  wow, really nice work and the result looks awesome! I'll put this into
>  x86.git and see how it goes.
>
>         Ingo
>
Thanks ingo. I'll hook up to the next part as soon as I can.


-- 
Glauber  Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
