Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187AbZJWXfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbZJWXfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 19:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbZJWXfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 19:35:11 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:60220 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZJWXfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 19:35:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=SK4WoDBFZzGQJ8hpjM1dqkizwgz7hNVWVJ8LnzamgZwLgJZ2aPbb/oZlvpd7Z1bE1b
         sYc2LNmX8oCX2JpDAr9jOK/jhZmdnR+30UeAhCUucftJXV3HxyGPE0H6wJPtc0ut582G
         jMWhFk/JS5HwW9MpZO4vedSgRZWk+efOsw45w=
MIME-Version: 1.0
Date: Fri, 23 Oct 2009 16:35:14 -0700
Message-ID: <9a0aa30d0910231635p7a692089vb92d2b35051c23ae@mail.gmail.com>
Subject: scheduling tasklets on remote cpu
From: T D <td.lkml@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

[This is my first post to LKML. If this isn't the right list for my
questions, can someone pl. point me to an appropriate list? Thanks.]

I've couple of questions wrt tasklets on an SMP system and the 2.6.30
kernel and would appreciate some clarifications.

1. When a top half schedules a tasklet to take care of deferred
processing, is it possible to schedule the tasklet to run on a
different cpu (than the one that handled the top half)? I looked up
softirq.c and don't see any such api for tasklets, although there is
one for softirq's.

2. Also, would there be any issues with a simple api that took the
specified tasklet from one CPU's tasklet queue/vector and moved it to
another CPU's queue?

Thanks!
