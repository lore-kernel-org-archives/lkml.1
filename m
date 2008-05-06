Return-Path: <linux-kernel-owner+w=401wt.eu-S1761102AbYEFNCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761102AbYEFNCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 09:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbYEFNCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 09:02:41 -0400
Received: from qb-out-0506.google.com ([72.14.204.227]:34793 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbYEFNCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 09:02:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=vpt2lh/3g0rCyLGMlivz40LKgnStEDcbmErVEzTero+sOLlWDj4CBgI4CltF2WZJ7KGopcW6T/Dyfz5fbw8iXu/O0bP115ieBwSel8jIQ/SiHmx8Yp2bX4nI6xddJLKZLvpnt4WNtJkMoQzjiNy8oE9YUAhX78hoyMt7FbsmWrw=
Message-ID: <2f11576a0805060602gf4cf0f9t85391939146efccf@mail.gmail.com>
Date: Tue, 6 May 2008 22:02:38 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] mm/cgroup.c add error check
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Paul Menage" <menage@google.com>, "Li Zefan" <lizf@cn.fujitsu.com>
In-Reply-To: <87wsm7bo1n.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080506195216.4A6D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <87wsm7bo1n.fsf@basil.nowhere.org>
X-Google-Sender-Auth: d202ead81dd51c64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > on heavy workload, call_usermodehelper() may failure
>  > because it use kzmalloc(GFP_ATOMIC).
>
>  Better just fix it to not use GFP_ATOMIC in the first place.

Ah, makes sense.
I'll try toi create that patch.

but if GFP_KERNEL is used, We still need error check, IMHO.
