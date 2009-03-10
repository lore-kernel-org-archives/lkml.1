Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbZCJRru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbZCJRru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbZCJRrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:47:40 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57615 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756368AbZCJRrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:47:39 -0400
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Nathan Lynch <ntl@pobox.com>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20090310174517.GA12101@us.ibm.com>
References: <20090305163857.0C18F3FD@kernel>
	 <20090310105702.43eb1402@thinkcentre.lan>
	 <20090310162026.GA9354@us.ibm.com>
	 <20090310122320.313491ce@thinkcentre.lan>
	 <20090310174517.GA12101@us.ibm.com>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 10:47:30 -0700
Message-Id: <1236707250.10626.174.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 12:45 -0500, Serge E. Hallyn wrote:
> > Are you saying that the message should identify the child instead of
> > the parent as the uncheckpointable task?
> 
> Yes.  The parent may have opened the fd (or, importantly, may NOT have)
> but the child is the one now getting that 'dirty' fd and being newly
> marked uncheckpointable.

Yeah.  It is kinda the parent's *fault* but this is the spot where we've
chosen to 'taint' the child.  If I were looking back in the logs, I'd be
wondering from where the child's 'taint' flag came from.  This is the
spot I should be looking for.

-- Dave

