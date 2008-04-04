Return-Path: <linux-kernel-owner+w=401wt.eu-S1759210AbYDDBdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210AbYDDBdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 21:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757324AbYDDBdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 21:33:14 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56090 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348AbYDDBdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 21:33:09 -0400
Subject: Re: [PATCH 1 of 6] hotplug-memory: refactor online_pages to
	separate zone growth from page onlining
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <47F58242.1030209@goop.org>
References: <5a397e7f3c1aeb7648b9.1207267541@localhost>
	 <1207271207.943.38.camel@nimitz.home.sr71.net>  <47F58242.1030209@goop.org>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 18:33:06 -0700
Message-Id: <1207272786.943.59.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-03 at 18:20 -0700, Jeremy Fitzhardinge wrote:
> Last time I posted this patch you complained about my name 
> "online_pages_zone", suggesting "grow_zone_span".  Since that already 
> existed, I took that as a hint to fold the two functions together.  Is 
> that not what you meant?

I'm obviously a doofus for suggesting a name that already existed. :)

You probably just want a name that lets the caller know that you're
growing both the pgdats and the zones somehow.  

-- Dave

