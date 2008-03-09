Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbYCIVnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbYCIVnB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 17:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbYCIVmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 17:42:50 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46002 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbYCIVmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 17:42:49 -0400
Message-ID: <47D459D5.2020101@garzik.org>
Date: Sun, 09 Mar 2008 17:42:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Junio C Hamano <junio@pobox.com>
CC: git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.5.4.4
References: <7vr6f31iwj.fsf@gitster.siamese.dyndns.org> <7vr6eknpjf.fsf@gitster.siamese.dyndns.org> <47D416C8.1020903@garzik.org> <7v1w6jod54.fsf@gitster.siamese.dyndns.org>
In-Reply-To: <7v1w6jod54.fsf@gitster.siamese.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano wrote:
> Jeff Garzik <jeff@garzik.org> writes:
> 
>> Junio C Hamano wrote:
>>> The latest maintenance release GIT 1.5.4.4 is available at the
>>> usual places:
>>>
>>>   http://www.kernel.org/pub/software/scm/git/
>>>
>>>   git-1.5.4.4.tar.{gz,bz2}			(tarball)
>>>   git-htmldocs-1.5.4.4.tar.{gz,bz2}		(preformatted docs)
>>>   git-manpages-1.5.4.4.tar.{gz,bz2}		(preformatted docs)
>>>   RPMS/$arch/git-*-1.5.4.4-1.$arch.rpm	(RPM)
>> Does it address the following issue, present in git-core-1.5.4.1-1.fc8?
>>
>> http://marc.info/?l=git&m=120423022832530&w=2
> 
> I do not think so.
> 
> Is it really an issue, or is it just a warning message unread/unfollowed?

It's not a warning message, it is an annoying delay that has been added 
to almost -every- local pull, impacting my main kernel workflow.

Further -- as my email demonstrated with examples -- it would repeatedly 
'git gc' on the same repository over and over again, for each 'git pull' 
or 'git rebase' that I did.  That is overly excessive.


> I am comparing the last line you quoted from the command output in that
> message, which suggests the user to run 'git prune', and your comment on
> the next line in that message that says "I regularly run 'git gc'", and
> scratching my head.  I cannot tell if you regularly run 'git prune' or not
> from it...

Yes, I regularly run both 'git gc' and 'git prune'.

But since (ref original email) I was doing some rebasing, there are 
inevitably changesets left dangling after such an operation.

	Jeff



