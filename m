Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbXD0Hv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbXD0Hv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 03:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbXD0Hv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 03:51:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:57552 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbXD0HvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 03:51:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BSZHa8CU3gO1QGclooB7xWSq+jLeFaraKgK68fVnHDAzgYnEC3+O62XzZcvtn0doPl/WdvlyfA7VZs0PAuGoBVToZmPWh1zfDaylBvUADwvOgUq+1mZp3UFWKt9Y44Izx6JVxso5qvftpnqobsMADldtrfJtph2gFkdeC/gczNQ=
Message-ID: <84144f020704270051jfdbe19cy904b52b8ba084e34@mail.gmail.com>
Date: Fri, 27 Apr 2007 10:51:22 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Back to the future.
Cc: "Xavier Bestel" <xavier.bestel@free.fr>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0704261021160.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com>
	 <1177573348.5025.224.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
	 <1177607026.30284.197.camel@frg-rhel40-em64t-04>
	 <alpine.LFD.0.98.0704261021160.9964@woody.linux-foundation.org>
X-Google-Sender-Auth: bc9176a6d09339d5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/26/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> In fact, I personally feel that I shouldn't even have merged
> userspace-swsusp, but if Andrew thinks it needs to be merged, my personal
> feelings simply don't matter that much. I have to trust people. But yes,
> as far as *I* am personally concerned, I think it was a mistake to merge
> it.

While the ioctl() interface is horrid, I think it's actually in
principle pretty close to your snapshot_system()/resume_snapshot().
The ugliness probably comes from the fact that suspend to RAM and
snapshot/shutdown are interleaved there too.
