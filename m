Return-Path: <linux-kernel-owner+w=401wt.eu-S1760970AbXEQGJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760970AbXEQGJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 02:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755695AbXEQGJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 02:09:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755570AbXEQGJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 02:09:47 -0400
Date: Thu, 17 May 2007 02:08:10 -0400
From: Dave Jones <davej@redhat.com>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Joachim Deguara <joachim.deguara@amd.com>
Subject: Re: [BUG] (regression) AMD k6-III/450 won't boot w/2.6.22-rc1
Message-ID: <20070517060810.GK30166@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Bob Tracy <rct@gherkin.frus.com>, Chuck Ebbert <cebbert@redhat.com>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
	Joachim Deguara <joachim.deguara@amd.com>
References: <20070516210716.GB16810@redhat.com> <20070517043646.B41D6DBA1@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070517043646.B41D6DBA1@gherkin.frus.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 11:36:46PM -0500, Bob Tracy wrote:
 > Dave Jones wrote:
 > > Bob, does this patch make it boot again for you?
 > > 
 > > 	Dave
 > > 
 > > Some AMD K6's advertise machine check capability, but don't actually
 > > have an Intel compatible implementation. It also doesn't actually work,
 > > so don't advertise it as being present.
 > > 
 > > Signed-off-by: Dave Jones <davej@redhat.com>
 > 
 > NAK.  No difference.  Identical panic message.  (Yes, I double-checked
 > to make sure I was booting the patched kernel :-)).

Hmm, odd.
Does reverting the patch that Chuck fingered fix it? 

	Dave

-- 
http://www.codemonkey.org.uk
