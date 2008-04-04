Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbYDDBMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbYDDBMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 21:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbYDDBM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 21:12:28 -0400
Received: from gw.goop.org ([64.81.55.164]:33376 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbYDDBM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 21:12:27 -0400
Message-ID: <47F58041.8080204@goop.org>
Date: Thu, 03 Apr 2008 18:11:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 4 of 6] hotplug-memory: use common online_page
References: <a2a6c0b2e3fdc19d18b4.1207267544@localhost>	 <1207270061.943.21.camel@nimitz.home.sr71.net>  <47F57CA0.1000500@goop.org> <1207270805.943.33.camel@nimitz.home.sr71.net>
In-Reply-To: <1207270805.943.33.camel@nimitz.home.sr71.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> I guess we could just make the copies conditional on CONFIG_HIGHMEM and
> define them both next to each other.  It's really a highmem thing more
> than a per-arch thing.

Sounds good to me.  On that subject, how different are the various 
arch_add_memory() functions really?  There seems to be a lot of common 
stuff in there.

    J

