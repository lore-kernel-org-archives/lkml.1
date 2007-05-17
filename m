Return-Path: <linux-kernel-owner+w=401wt.eu-S1761383AbXEQEg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761383AbXEQEg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 00:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbXEQEgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 00:36:52 -0400
Received: from gherkin.frus.com ([192.158.254.49]:37546 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbXEQEgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 00:36:51 -0400
Subject: Re: [BUG] (regression) AMD k6-III/450 won't boot w/2.6.22-rc1
In-Reply-To: <20070516210716.GB16810@redhat.com> "from Dave Jones at May 16,
 2007 05:07:16 pm"
To: Dave Jones <davej@redhat.com>
Date: Wed, 16 May 2007 23:36:46 -0500 (CDT)
CC: Chuck Ebbert <cebbert@redhat.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Joachim Deguara <joachim.deguara@amd.com>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070517043646.B41D6DBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> Bob, does this patch make it boot again for you?
> 
> 	Dave
> 
> Some AMD K6's advertise machine check capability, but don't actually
> have an Intel compatible implementation. It also doesn't actually work,
> so don't advertise it as being present.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

NAK.  No difference.  Identical panic message.  (Yes, I double-checked
to make sure I was booting the patched kernel :-)).

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
