Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbZEPOZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbZEPOZZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 10:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbZEPOZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 10:25:10 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:59363 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbZEPOZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 10:25:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=icY9FqIpKwO6MELqcLApcogg/B9+Pr8FFJp2k+4Go4Ow6sgWaIeW76G90sNh/XDRJf
         SULgKku+A6axVbqmGCLGUZtt5XG4lKr75449RDngN+3DWWOzvbo4631thbTPipSs2HvW
         ANT2XDTt4lDrtAYBSIR2RZExQijSJVIWlfQ9c=
MIME-Version: 1.0
In-Reply-To: <2c0942db0905151102y4f144437xa02632effccda72c@mail.gmail.com>
References: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com>
	 <2c0942db0905151102y4f144437xa02632effccda72c@mail.gmail.com>
Date: Sat, 16 May 2009 19:55:09 +0530
Message-ID: <93655eb70905160725u2ae9e11sec4abe9f95be18ed@mail.gmail.com>
Subject: Re: unresponsiveness on linux desktop during file copy
From: Satish Eerpini <eerpini@gmail.com>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Rik van Riel <riel@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Which kernel version? If it's something recent, your programs may be
> getting swapped out due to a flaw in the latest kernels, where it
> accidentally prefers caching file data over mapped pages. If that's
> the case, Rik (cc:d) is working on patches to address the issue, and
> may appreciate another tester.

well I went through http://kerneltrap.org/node/3000 on kerneltrap ,
which I think is what you are pointing out here. Well I checked the
"swappiness" parameter on my system and it is set to 60 , and bravely
I changed it to '0', while the system appeared to have become a lot
more responsive, I see no difference in the statistics:

Linux 2.6.29.1 (satish) 	05/16/2009

07:49:43 PM     CPU     %user     %nice   %system   %iowait    %steal     %idle
07:49:46 PM     all      7.30      0.00            8.25         40.00
    0.00     44.44
07:49:49 PM     all      7.21      0.00            9.40          36.36
     0.00     47.02
07:49:52 PM     all      8.62      0.00            9.40          34.80
     0.00     47.18
07:49:55 PM     all      7.26      0.00            8.36          37.07
     0.00     47.32
07:49:58 PM     all      7.89      0.00           9.15           36.59
     0.00     46.37
Average:           all        7.66     0.00          8.92
36.96      0.00     46.47

so there is still a huge IOWAIT , ..


Cheers
Satish
-- 
http://satish.playdrupal.com
