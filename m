Return-Path: <linux-kernel-owner+w=401wt.eu-S933965AbYCTACE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965AbYCTACE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162456AbYCSWsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:48:54 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:38359 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162447AbYCSWsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:48:53 -0400
Date: Wed, 19 Mar 2008 15:48:14 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, akpm <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH BUGFIX -rc5] Smack: Do not dereference NULL ipc object
Message-ID: <20080319224814.GC19346@sequoia.sous-sol.org>
References: <20080314231034.GA1701@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080314231034.GA1701@ubuntu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ahmed S. Darwish (darwish.07@gmail.com) wrote:
> In the SYSV ipc msgctl(),semctl(),shmctl() family, if the user passed
> *_INFO as the desired operation, no specific object is meant to be 
> controlled and only system-wide information is returned. This leads
> to a NULL IPC object in the LSM hooks if the _INFO flag is given.
> 
> Avoid dereferencing this NULL pointer in Smack ipc *ctl() methods.

Casey, this looks quite legit to me.  Can you ack please.

thanks,
-chris
