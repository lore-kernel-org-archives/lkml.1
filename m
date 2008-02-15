Return-Path: <linux-kernel-owner+w=401wt.eu-S934490AbYBOACr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934490AbYBOACr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759915AbYBOACj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:02:39 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:17314 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759296AbYBOACi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:02:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ow7FSm/gXWVsoM8Y0LGDaRLT4WQalBMoN/UMUfA3OYHrWBWkvbLphOVw5lRcPMTztOD+a2qrC1DhlNp1nZcomopUF30NknsuU/2mR4ZLJ+TWjS3+sNhzCo3iHUE47683gzLmNb3iwrgf7IKLdJqIOz2UZ7lRRaalTR2FTic1rfE=
Message-ID: <47B4D697.3030106@gmail.com>
Date: Fri, 15 Feb 2008 09:02:31 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: Disk schedulers
References: <20080214162104.GA5347@ics.muni.cz>
In-Reply-To: <20080214162104.GA5347@ics.muni.cz>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek wrote:
> Hello,
> 
> whom should I blame about disk schedulers?
> 
> I have the following setup:
> 1Gb network
> 2GB RAM
> disk write speed about 20MB/s
> 
> If I'm scping file (about 500MB) from the network (which is faster than the
> local disk), any process is totally unable to read anything from the local disk
> till the scp finishes. It is not caused by low free memory, while scping
> I have 500MB of free memory (not cached or buffered).
> 
> I tried cfq and anticipatory scheduler, none is different.
> 

Does deadline help?

-- 
tejun
