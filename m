Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbYGRUhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbYGRUhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 16:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761281AbYGRUhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 16:37:12 -0400
Received: from n5b.bullet.mail.ac4.yahoo.com ([76.13.13.75]:39267 "HELO
	n5b.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761142AbYGRUhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 16:37:11 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 621176.19029.bm@omp116.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=cSkDXrV2jXIv9i1UvW5rYzmbtBWTACuQfb12N9k4g99hIEx8zVURknoqpib1b3P38vm2/TABhG4oI+9zFw6VbpTqfGVE8uhewmdtRbA5CKtJWLZFlpiaxOJgx+Cwh3vzQ+PIOvUa2ud75PWbHF4pbMin3T/MHsmdky7emQf22pU=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Fri, 18 Jul 2008 13:37:10 -0700 (PDT)
From: Soumyadip Das Mahapatra <soumya.linux@yahoo.com>
Subject: Surprising Code In sound/core/pcm_native.c In Recent Git Tree
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <416584.18514.qm@web59516.mail.ac4.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone!

When i was reading the code in sound/core/pcm_native.c in
recent git tree, i got stuck in  line no 3258. It is something
like this
snd_assert(substream != NULL, goto out);

That (goto statement) surprised me for a while unless i came to
know snd_assert() is a macro (as expected!). Previous version
too had a return statement in it.

The point is that can we have a nicer code? Because this type
of code is sometimes __CONFUSING__.

Thanks :-)



      

