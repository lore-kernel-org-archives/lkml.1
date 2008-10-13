Return-Path: <linux-kernel-owner+w=401wt.eu-S1760888AbYJMTBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760888AbYJMTBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 15:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbYJMTBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 15:01:07 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:18539 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011AbYJMTBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 15:01:07 -0400
Message-ID: <48F39AE2.5040905@oracle.com>
Date: Mon, 13 Oct 2008 12:00:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Neshama Parhoti <pneshama@gmail.com>
CC: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: section mismatch with a platform driver
References: <912ec82a0810130119g795c91ffr1083d7e8459a6db1@mail.gmail.com>	 <20081013085111.GB29938@cs181140183.pp.htv.fi>	 <912ec82a0810130228m3e9e11bcyfcabe1ab46fb0b6b@mail.gmail.com>	 <20081013090133.a58116a2.randy.dunlap@oracle.com>	 <912ec82a0810130929h42574fav985e922ad019b8f5@mail.gmail.com>	 <48F377F4.7070502@oracle.com> <912ec82a0810131158o316201a5o803cb46c67c1b065@mail.gmail.com>
In-Reply-To: <912ec82a0810131158o316201a5o803cb46c67c1b065@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neshama Parhoti wrote:
> On Mon, Oct 13, 2008 at 6:31 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>> Does that mean that all drivers with __init in their probe functions are bogus ?
>> It depends.  If your platform doesn't support hotplug, then it's possible
>> that the probe function is only called during system init, so it would be OK.
> 
> Hmm any idea then why did it give me a section mismatch warning ?

Just because the probe function is marked __init.
