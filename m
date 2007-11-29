Return-Path: <linux-kernel-owner+w=401wt.eu-S1761017AbXK2P7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761017AbXK2P7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 10:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbXK2P7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 10:59:03 -0500
Received: from k2smtpout03-02.prod.mesa1.secureserver.net ([64.202.189.172]:53247
	"HELO k2smtpout03-02.prod.mesa1.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751440AbXK2P7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 10:59:01 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Nov 2007 10:59:01 EST
Message-ID: <20071129105220.v40i22q4gw4cgoso@intranet.digizenstudio.com>
Date: Thu, 29 Nov 2007 10:52:20 -0500
From: Jing Xue <jingxue@digizenstudio.com>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org, git@vger.kernel.org
Subject: Re: git guidance
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Quoting Al Boldi <a1426z@gawab.com>:

> Sure, browsing is the easy part, but Version Control starts when things
> become writable.

But how is that supposed to work?  What happens when you make some
changes to a file and save it?  Do you want the "git file system" to
commit it right aways or wait until you to issue a "commit" command?
The first behavior would obviously be wrong, and the second would make
the "file system" not operationally transparent anyways. Right?

By the way, the only SCM I have worked with that tries to mount its
repository (or a view on top of it) as a file system is ClearCase with
its dynamic views. And, between the buggy file system implementation,
the intrusion on workflow, and the lack of scalability, at least in
the organization I worked for, it turned out to be a horrible,
horrible, horrible idea.

Cheers.
-- 
Jing Xue


