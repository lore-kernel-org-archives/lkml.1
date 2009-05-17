Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbZEQIyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbZEQIyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 04:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZEQIyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 04:54:10 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:8163 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZEQIyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 04:54:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MO6JWrJDXNkC6uvy4KaeqcMXKMJTURZTk4x4WL/QP0LxDCRDrjl9uxJURsh5HLewdM
         /PmhZuI/aC0voIr3wuD8J7REXEb4eQUZzagAK0eZ4B3BDM8s2b6aJaFxVjKfgEASJ6/o
         RaywsO+9XRU1O2sFmM475JD28ujPIETxGqUgI=
Message-ID: <4A0FD0AD.4030402@gmail.com>
Date: Sun, 17 May 2009 02:54:05 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Satish Eerpini <eerpini@gmail.com>
CC: Mark Knecht <markknecht@gmail.com>, Rik van Riel <riel@redhat.com>,
       Ray Lee <ray-lk@madrabbit.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: unresponsiveness on linux desktop during file copy
References: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com>	 <5bdc1c8b0905151012x51c19b5cv639cadab1cee3849@mail.gmail.com>	 <93655eb70905151024o634f8432j6c3db85df1f6ddfc@mail.gmail.com>	 <5bdc1c8b0905151120p5aa58318t1765544fbbb695b2@mail.gmail.com>	 <93655eb70905151938y558bf86flcfb7c6b6b2c171c6@mail.gmail.com>	 <5bdc1c8b0905151947j326d31d9k5c7b1074af2b0bf0@mail.gmail.com>	 <93655eb70905152012j2a40d2e0ta413a5e9dee34d46@mail.gmail.com>	 <5bdc1c8b0905152037r614eaf8ft222c7a6294f2e80f@mail.gmail.com> <93655eb70905152352n6f82ef9dubb9b36e5be161ac7@mail.gmail.com>
In-Reply-To: <93655eb70905152352n6f82ef9dubb9b36e5be161ac7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Satish Eerpini wrote:
>> Do you believe this was working better on an earlier kernel? If so you
>> might drop back and see if these commands work better. If so that
>> would suggest a regression of some type.
> 
> I remember good performance with 2.6.26.x series, ... but I could not
> try that out, ,... things on a 2.6.27.23 kernel seem no better :
> 
> Linux 2.6.27.23 (satish) 	05/16/2009
> 
> 12:11:18 PM     CPU     %user     %nice   %system   %iowait    %steal     %idle
> 12:11:21 PM     all      0.00      0.00      3.92     75.65      0.00     20.42
> 12:11:24 PM     all      0.00      0.00      3.55     67.85      0.00     28.59
> 12:11:27 PM     all      0.16      0.00      4.51     45.09      0.00     50.24
> 12:11:30 PM     all      0.00      0.00      3.59     44.77      0.00     51.63
> 12:11:33 PM     all      0.16      0.00      5.25     82.51      0.00     12.08
> Average:        all      0.06      0.00      4.17     63.24      0.00     32.53
> 
> the average disk speed was about 10.5 MB/s, indeed the average IOWAIT
> is more than that in the latest kernel, I will see if I can test it on
> a 2.6.26.x kernel or earlier one and send you guys the stats.

High iowait during a file copy with no other activity is entirely 
normal. If you have a core that has nothing to do but wait for IO to 
complete, you'll get iowait time. This isn't indicating a problem.
