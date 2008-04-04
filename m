Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbYDDA5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbYDDA5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYDDA5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:57:00 -0400
Received: from gw.goop.org ([64.81.55.164]:46200 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbYDDA47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:56:59 -0400
Message-ID: <47F57CA0.1000500@goop.org>
Date: Thu, 03 Apr 2008 17:56:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 4 of 6] hotplug-memory: use common online_page
References: <a2a6c0b2e3fdc19d18b4.1207267544@localhost> <1207270061.943.21.camel@nimitz.home.sr71.net>
In-Reply-To: <1207270061.943.21.camel@nimitz.home.sr71.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> This is OK, but I do think the __weak stuff can make it a bit
> counter-intuitive to track down which version is actually getting used.
> Are there any people the currently override that __weak?
>
> If not, we should probably just kill it.
>   

Yes, x86-32 has a different implementation.

    J
