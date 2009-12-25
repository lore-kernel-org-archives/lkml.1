Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635AbZLYI2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbZLYI2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 03:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbZLYI2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 03:28:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:42977 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbZLYI2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 03:28:13 -0500
Date: Fri, 25 Dec 2009 09:30:28 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, "Smith, GeoffX" <geoffx.smith@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Michael Stone <michael@laptop.org>
Subject: Re: [PATCH] prctl: return MCE process flags through pointer
Message-ID: <20091225093028.5a0afaf7@infradead.org>
In-Reply-To: <20091223021807.abbd993e.akpm@linux-foundation.org>
References: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE1829@orsmsx510.amr.corp.intel.com>
	<87hbricwz8.fsf@basil.nowhere.org>
	<20091222173424.980d5d33.akpm@linux-foundation.org>
	<20091223095223.GB20539@basil.fritz.box>
	<20091223021807.abbd993e.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Dec 2009 02:18:07 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> Regarding "prctl: return timerslack through pointer": are there any
> known users of PR_GET_TIMERSLACK yet?

I only have a SET_ user, not a GET_; I added the GET_ for API symmetry.

> 
> Why are task_struct.timer_slack_ns and
> task_struct.default_timer_slack_ns unsigned long, btw?  AFACIT we
> could make them unsigned ints.

I can't remember any particular reason at this point.
 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
