Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbZJTH14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbZJTH14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 03:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755895AbZJTH1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 03:27:55 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:45745 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843AbZJTH1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 03:27:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=t//FNf98pYKQ4qGjcNt9n87OhS29ln94b9z+3xtuglR65rICpqE0GTh9V5poQgNNPB
         Lau6rPMJAJ8UZtqr5SqW1TSEYgYuH3UFfLxuTMl8P0Z/R32gWkVftWZtag79oJpNPqk0
         je/lhuxFgLV+cbj7G2dMecgMVMx5sMHXOa6zQ=
Date: Tue, 20 Oct 2009 09:27:53 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@gmail.com>, linux-kernel@vger.kernel.org,
       Andreas Mohr <andi@lisas.de>
Subject: Re: [Patch] acerhdf: Return temperature in milidegree
Message-ID: <20091020072752.GA9326@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Peter Feuerer <peter@piie.net>,
	Borislav Petkov <petkovbb@gmail.com>, linux-kernel@vger.kernel.org,
	Andreas Mohr <andi@lisas.de>
References: <20091019102116.222ff9c3.peter@piie.net>
 <9ea470500910191151j370cec68w67ee8e31f42f3303@mail.gmail.com>
 <cone.1255986667.852662.3188.1000@deskpiie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cone.1255986667.852662.3188.1000@deskpiie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 11:11:07PM +0200, Peter Feuerer wrote:
> I just had a look at the documentation concerning this topic:
> 
> Documentation/thermal/sysfs-api.txt:162
> 
> temp           Current temperature as reported by thermal zone (sensor)
>            Unit: millidegree Celsius
>            RO
>            Required
> 
> 
> It is expected to be in millidegree, so I think we should discuss,
> modify and apply the patch.

Well well, looka here, it is an interface! I guess the temperature has
to be in millidegrees for better granularity or similar. Now userspace
has to do temp / 1000.0 and so on.

In that case, the patch should be applied. I'll give it a run later.

Minor nitpick: Add the sysfs-api requirement to the commit message
instead of "userspace applications."

Thanks.

-- 
Regards/Gruss,
    Boris.
