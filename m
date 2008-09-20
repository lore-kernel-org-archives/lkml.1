Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbYITHo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbYITHo2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 03:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYITHoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 03:44:20 -0400
Received: from ns1.suse.de ([195.135.220.2]:54681 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbYITHoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 03:44:19 -0400
Date: Sat, 20 Sep 2008 10:10:49 +0200
From: Olaf Dabrunz <od@suse.de>
To: Martin Bligh <mbligh@google.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "od Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: Unified tracing buffer
Message-ID: <20080920081049.GC4491@suse.de>
Mail-Followup-To: Martin Bligh <mbligh@google.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Mathieu Desnoyers <compudj@krystal.dyndns.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	"od Frank Ch. Eigler" <fche@redhat.com>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <20080919144258.ac787fdf.randy.dunlap@oracle.com> <33307c790809191457y3ebffa28xa6d9ab6431554618@mail.gmail.com> <20080919224109.GB4491@suse.de> <33307c790809191519k7c1bcce7y3fa37efc23b0f9c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <33307c790809191519k7c1bcce7y3fa37efc23b0f9c@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19-Sep-08, Martin Bligh wrote:
> >> Sorry, probably lots of implicit assumptions in there that I forgot to explain
> >
> > Ids for event types. Either allocated dynamically, if the tracer needs
> > new ids on each use, or statically assigned for others (like my fctrace
> > or Steven's ftrace, I believe). Should we have a reserved range / registry
> > for static allocation, maybe something like a very simple version of
> > devices.txt?
> 
> Sure, but it's per-tracer, so hopefully won't be a big problem (eg fctrace
> would have a different event-id namespace from blktrace)

Ah, that is right. We can distinguish them.

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

