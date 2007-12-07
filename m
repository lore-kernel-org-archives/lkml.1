Return-Path: <linux-kernel-owner+w=401wt.eu-S1755085AbXLGKyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbXLGKyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 05:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbXLGKyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 05:54:23 -0500
Received: from [212.12.190.195] ([212.12.190.195]:60321 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751841AbXLGKyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 05:54:21 -0500
From: Al Boldi <a1426z@gawab.com>
To: Andreas Ericsson <ae@op5.se>
Subject: Re: git guidance
Date: Fri, 7 Dec 2007 13:53:11 +0300
User-Agent: KMail/1.5
Cc: Johannes Schindelin <Johannes.Schindelin@gmx.de>,
       Phillip Susi <psusi@cfl.rr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jing Xue <jingxue@digizenstudio.com>, linux-kernel@vger.kernel.org,
       git@vger.kernel.org
References: <20071129105220.v40i22q4gw4cgoso@intranet.digizenstudio.com> <200712070737.18519.a1426z@gawab.com> <475906F7.5010309@op5.se>
In-Reply-To: <475906F7.5010309@op5.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712071353.11654.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Ericsson wrote:
> So, to get to the bottom of this, which of the following workflows is it
> you want git to support?
>
> ### WORKFLOW A ###
> edit, edit, edit
> edit, edit, edit
> edit, edit, edit
> Oops I made a mistake and need to hop back to "current - 12".
> edit, edit, edit
> edit, edit, edit
> publish everything, similar to just tarring up your workdir and sending
> out ### END WORKFLOW A ###
>
> ### WORKFLOW B ###
> edit, edit, edit
> ok this looks good, I want to save a checkpoint here
> edit, edit, edit
> looks good again. next checkpoint
> edit, edit, edit
> oh crap, back to checkpoint 2
> edit, edit, edit
> ooh, that's better. save a checkpoint and publish those checkpoints
> ### END WORKFLOW B ###

### WORKFLOW C ###
for every save on a gitfs mounted dir, do an implied checkpoint, commit, or 
publish (should be adjustable), on its privately created on-the-fly 
repository.
### END WORKFLOW C ###

For example:

  echo "// last comment on this file" >> /gitfs.mounted/file

should do an implied checkpoint, and make these checkpoints immediately 
visible under some checkpoint branch of the gitfs mounted dir.

Note, this way the developer gets version control without even noticing, and 
works completely transparent to any kind of application.


Thanks!

--
Al

