Return-Path: <linux-kernel-owner+w=401wt.eu-S1756340AbZCFXiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbZCFXiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 18:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbZCFXiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 18:38:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34871 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbZCFXiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 18:38:07 -0500
Message-ID: <49B1B2E9.5050507@zytor.com>
Date: Fri, 06 Mar 2009 15:34:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Yinghai Lu <yinghai@kernel.org>, mingo@elte.hu,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: introduce bootmem_state
References: <> <1236257708-27269-7-git-send-email-penberg@cs.helsinki.fi> <49B02498.9080300@kernel.org> <49B02C68.1030203@cs.helsinki.fi> <49B0640A.5080607@kernel.org> <49B0BF46.4080405@zytor.com> <49B19FB4.40909@goop.org>
In-Reply-To: <49B19FB4.40909@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> Please, no.  system_state should be deprecated; its hard enough to have 
> a notion of some kind of system-wide state, but putting subsystem 
> specific substates into it just makes things worse.
> 

Does it?  It seems to me to have a bunch of state variables which can 
interact in $DEITY knows how many ways sounds like a bad idea.

	-hpa

