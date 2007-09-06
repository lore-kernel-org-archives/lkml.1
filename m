Return-Path: <linux-kernel-owner+w=401wt.eu-S1757752AbXIFMKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752AbXIFMKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 08:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbXIFMKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 08:10:47 -0400
Received: from gherkin.frus.com ([192.158.254.49]:38532 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbXIFMKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 08:10:46 -0400
Subject: Re: [BUG] 2.6.23-rc5 panics
In-Reply-To: <alpine.LFD.0.999.0709061127450.26804@enigma.security.iitk.ac.in>
 "from Satyam Sharma at Sep 6, 2007 11:32:20 am"
To: Satyam Sharma <satyam@infradead.org>
Date: Thu, 6 Sep 2007 07:10:43 -0500 (CDT)
CC: Roland Dreier <rdreier@cisco.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070906121043.E2EB9DBA2@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> -rc5 users should apply commit 5c127c58ae9bf196d787815b1bd6b0aec5aee816
> (or else just move to latest -git).

I applied the small "net/ipv4/tcp_input.c" patch, and that seems to have
done the trick.  Thanks for the pointer to the fix!

-- 
------------------------------------------------------------------------
Bob Tracy          |  "They couldn't hit an elephant at this dist- "
rct@frus.com       |   - Last words of Union General John Sedgwick,
                   |  Battle of Spotsylvania Court House, U.S. Civil War
------------------------------------------------------------------------
