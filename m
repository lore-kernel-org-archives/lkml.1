Return-Path: <linux-kernel-owner+w=401wt.eu-S1030357AbXDJWUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030357AbXDJWUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030401AbXDJWUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:20:13 -0400
Received: from smtprelay06.ispgateway.de ([80.67.18.44]:59303 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030357AbXDJWUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:20:10 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: init's children list is long and slows reaping children.
Date: Wed, 11 Apr 2007 00:20:33 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, Robin Holt <holt@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com> <Pine.LNX.4.64.0704091944580.6730@woody.linux-foundation.org> <461B3795.4020902@garzik.org>
In-Reply-To: <461B3795.4020902@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704110020.35746.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 April 2007, Jeff Garzik wrote:
> That's why I feel thread creation -- cheap under Linux -- is quite 
> appropriate for many of these situations.

Maybe that (thread creation) can be done at open(), socket-creation, 
service request, syscall or whatever event triggers a driver/subsystem 
to actually queue work into a thread.

And when there is a close(), socket-destruction, service completion
or whatever these threads can be marked for destruction and destroyed
by a timer or even immediately.

Regards

Ingo Oeser

-- 
If something is getting cheap, it is getting wasted just because it is cheap.
