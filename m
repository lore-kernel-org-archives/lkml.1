Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbZLAV7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbZLAV7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 16:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbZLAV7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 16:59:36 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53994 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbZLAV7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 16:59:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=C+LlfL1P0NnQfwk6GnfqZpky5neEmD8C1K9lk3nCgRV1h4mRftlbjrhW7R8Is1BMEh
         mYAimbbNfwsSTrm5yIyDsnYqsgRFMbKN67iDiVOj+ren6n9A8xzaiVUe/Scbhn4Jugzq
         T8ItyBoVZ/18Aj+TXjLb1LPPbkOJ71ysxbLLs=
Message-ID: <4B15918E.4000200@gmail.com>
Date: Tue, 01 Dec 2009 23:58:38 +0200
From: Lior Dotan <liodot@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091201)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Linux 2.6.32-rc8 - T500 fails to suspend to RAM
References: <4B151FE2.3090807@gmail.com> <200912012246.58383.rjw@sisk.pl>
In-Reply-To: <200912012246.58383.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday 01 December 2009, Lior Dotan wrote:
>   
>> Hi,
>>
>> Ever since I've upgraded to rc8, my T500 fails to suspend to RAM for the
>> second time. Suspending for the first time works ok but when I resume and
>> later try to suspend again the screen gets blank and the moon LED blinks
>> forever. rc6 & rc7 as well as 2.6.31 worked great with out a problem.
>>     
>
> Well, I don't see any particular change that might cause the symptoms you
> describe between -rc7 and -rc8.  If this is 100% reproducible, I guess
> bisecting is the only option at the moment.
>   
It is very easy to reproduce, I will try to bisect it.
