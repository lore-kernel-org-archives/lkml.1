Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbYDJCjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbYDJCjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 22:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbYDJCji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 22:39:38 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:35386 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbYDJCjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 22:39:37 -0400
Date: Wed, 9 Apr 2008 19:38:18 -0700
From: sukadev@us.ibm.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@osdl.org>, clg@fr.ibm.com, serue@us.ibm.com,
       "David C. Hansen" <haveblue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] clone64() and unshare64() system calls
Message-ID: <20080410023818.GD28477@us.ibm.com>
References: <20080409222611.GA28087@us.ibm.com> <47FD5899.2040206@zytor.com> <20080410010717.GA28477@us.ibm.com> <47FD6921.6090408@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FD6921.6090408@zytor.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin [hpa@zytor.com] wrote:
>> Yes, this was discussed before in the context of Pavel Emelyanov's patch
>> 	http://lkml.org/lkml/2008/1/16/109
>> along with sys_indirect().  While there was no consensus, it looked like
>> adding a new system call was better than open ended interfaces.
>
> That's not really an open-ended interface, it's just an expandable bitmap.

Yes, we liked such an approach earlier too and its conceivable that we
will run out of the 64-bits too :-)

But as Jon Corbet pointed out in the the thread above, it looked like
adding a new system call has been the "traditional" way of solving this
in Linux so far and there has been no consensus on a newer approach.

Sukadev
