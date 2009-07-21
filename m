Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbZGUGXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbZGUGXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 02:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbZGUGW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 02:22:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60431 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627AbZGUGW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 02:22:58 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH 1/3] taskstats-fork: Add a new taskstats command to get notification on fork/clone
Date: Tue, 21 Jul 2009 11:54:42 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.23-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Guillaume Chazarain <guichaz@gmail.com>,
       procps-feedback@lists.sf.net, Albert Cahalan <albert@users.sf.net>
References: <200907211031.48294.knikanth@suse.de> <20090721060114.GS24157@balbir.in.ibm.com>
In-Reply-To: <20090721060114.GS24157@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907211154.42563.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 July 2009 11:31:14 Balbir Singh wrote:
> * Nikanth Karthikesan <knikanth@suse.de> [2009-07-21 10:31:48]:
> > Add a new taskstats command to register for notification, whenever a new
> > task forks in the cpumask specified.
>
> The changelog is sucky.. why do we need this? Why is proc-events not
> sufficient?

Ah.. proc-events was the exact thing, I was looking for! Thanks. But it seems 
there is no documentation for it? May be I didn't search properly...

BTW I did mention the need for this, in 
http://patchwork.kernel.org/patch/36451/ , but didn't invest time to write a 
good changelog here, as I suspected something exists already. Sorry. ;-(

[CC-ed iotop/top people, who were CC-ed in the above mail. So that they can 
consider using proc-events interface, if it was not considered/used already]

Thanks
Nikanth
