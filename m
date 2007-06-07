Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbXFGKuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbXFGKuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 06:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbXFGKup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 06:50:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbXFGKuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 06:50:44 -0400
From: Steve Grubb <sgrubb@redhat.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] Audit: Add TTY input auditing
Date: Thu, 7 Jun 2007 06:50:49 -0400
User-Agent: KMail/1.9.6
Cc: Miloslav Trmac <mitr@redhat.com>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>,
       Alexander Viro <aviro@redhat.com>
References: <4666832D.8080603@redhat.com> <Pine.LNX.4.61.0706071010510.1547@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0706071010510.1547@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706070650.50100.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 June 2007 04:13:42 Jan Engelhardt wrote:
> >Add TTY input auditing, used to audit system administrator's actions.
>
> _What_ exactly does it audit?

In theory, it should audit the actions performed by the sysadmin. This patch 
doesn't cover actions done via X windows interface.

> And why does it only audit sysadmin actions?

This is what's called out for in various security standards such as NISPOM, 
DCID 6/3, and PCI. Its all about non-repudiation.

> Is this supposed to be a keylogger?

Sort of. Its supposed to allow the Security Officer the ability to check on 
what an admin was doing if they were found to be attempting access to 
information outside their duties. Or if something is found to be 
misconfigured, they can backtrack and see how it became that way if that was 
important.

Some people try to be compliant with these security standards with user space  
tools like rootsh, but that is too easy to detect and defeat. And then it 
does not put its data into the audit system where its correlated with other 
system events. 

>What about tty output?

That is not required.

-Steve
