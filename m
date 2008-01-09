Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbYAIW70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbYAIW70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 17:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbYAIW7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 17:59:18 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:44359 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbYAIW7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 17:59:17 -0500
Message-ID: <478551A6.9050803@nortel.com>
Date: Wed, 09 Jan 2008 16:58:46 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Alasdair G Kergon <agk@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       gorcunov@gmail.com
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
References: <20080108164015.GC31504@one.firstfloor.org> <4d8e3fd30801081158j3e7292d0i939776342015b12d@mail.gmail.com> <1199909560.6245.67.camel@cinder.waste.org> <20080109224026.GA4039@agk.fab.redhat.com> <20080109224603.GH15612@one.firstfloor.org> <20080109224513.GF3510@agk.fab.redhat.com>
In-Reply-To: <20080109224513.GF3510@agk.fab.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jan 2008 22:58:50.0012 (UTC) FILETIME=[32B2C5C0:01C85313]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alasdair G Kergon wrote:
> On Wed, Jan 09, 2008 at 11:46:03PM +0100, Andi Kleen wrote:

>>struct inode *inode = file->f_dentry->d_inode;

> And oops if that's not defined?

Isn't this basically identical to what was being passed in to .ioctl()?

Chris
