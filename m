Return-Path: <linux-kernel-owner+w=401wt.eu-S933892AbXKPAZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892AbXKPAZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 19:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbXKPAY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 19:24:58 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:16863 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbXKPAY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 19:24:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nr4EG6cquGxWZe9s9M+CyB3G36S2g5muNAp3nfdH3PGk8+NoDnNGDagQ9Qx/H58cO0MqP5Tv1lxHmo9Wk35heFk0VuEObTKVK11R+4Iwcxu9ggBvy60HIvTlP3n5G2PmxoY15LAI7sw0VnG7YDaAsBviPp+IlKESpYjQWXW0FCg=
Message-ID: <75b66ecd0711151624n476d2e83xd1acbb23a5bffcf0@mail.gmail.com>
Date: Thu, 15 Nov 2007 19:24:57 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Stefan Monnier" <monnier@iro.umontreal.ca>
Subject: Re: Treat disk space like memory space
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <jwvr6irqhn2.fsf-monnier+gmane.linux.kernel@gnu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <jwvr6irqhn2.fsf-monnier+gmane.linux.kernel@gnu.org>
X-Google-Sender-Auth: dfa3391c13216959
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 15, 2007 5:24 PM, Stefan Monnier <monnier@iro.umontreal.ca> wrote:
> [ I realize this is probably better implemented outside of the kernel, but
>   it seems like it might be of interest here.  Please redirect me to
>   a more appropriate place if you can think of one (other than
>   /dev/null that is).  ]

It would require some kernel support to reclaim the storage from the
caching application rather than returning -ENOSPC when a "normal" app
needs the storage.  Even if you make the caching app free the space by
itself you need a kernel mechanism to signal it when this happens.

Lee
