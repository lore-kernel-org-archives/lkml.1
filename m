Return-Path: <linux-kernel-owner+w=401wt.eu-S1761505AbYDKRVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761505AbYDKRVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 13:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760590AbYDKRVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 13:21:31 -0400
Received: from el-out-1112.google.com ([209.85.162.181]:51829 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760497AbYDKRVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 13:21:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=slyliB9l+kfkLJpNdciJoAMHB0lt8uTTqsQ3t2nHOtMrx1nGFZESAknvBisvmhP1U1soe/2+AJTqPy+ZiNbrw0xcOxuJmIDcgsI6Xh959fOe5eEue+A5JZAzCxYAptbzUmmRHKwFzn7mCQ7NoRvWii4LJ3oCBRF+aBi8wv46asY=
Message-ID: <ba7d8f720804111021v25cc4688mf6e36f571fd2b388@mail.gmail.com>
Date: Fri, 11 Apr 2008 13:21:28 -0400
From: "Dan Upton" <upton.dan.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: CFS rq lock question
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm poking around with some scheduler stuff, and there's something I'm
not clear on for the CFS runqueue locks.  The comments before
__load_balance_iterator(...) in sched_fair.c suggests things can be
dequeued even though the runqueue lock is held.  Can things also be
added to the queue while the lock is held?  (Also, either way, what's
the rationale that dequeueing is a safe procedure when somebody else
holds a lock?)

-dan
