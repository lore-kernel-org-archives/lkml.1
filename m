Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZAaV5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZAaV5r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 16:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZAaV5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 16:57:39 -0500
Received: from mail-bw0-f12.google.com ([209.85.218.12]:38674 "EHLO
	mail-bw0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbZAaV5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 16:57:39 -0500
X-Greylist: delayed 41820 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Jan 2009 16:57:38 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Ojz+RCyfBsQi/T+/QaQgTYoF4cQMTMoklUYGLfeFbmMEOiMVzYROm7xM2xNLycrGuw
         E0g8xhRVeiL2PN6HJQnFmFt7DbCQJr5PBWi6mxsQJTpSrMr/tQ8k9Lml6pmwg7SXbobk
         fP7sHOXjRzWQrQVzHcosnsLpz9DzdyLG8RPd0=
MIME-Version: 1.0
Date: Sat, 31 Jan 2009 22:57:36 +0100
Message-ID: <541298b90901311357o593a4339t46a44e8933bb1a6b@mail.gmail.com>
Subject: processes/threads monitor
From: Angelo Borsotti <angelo.borsotti@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I wish to be personally CC'ed the answers/comments posted to the list
in response to this posting


In 2004, a thread appeared in the mailing list, stating the need for
some means to
monitor processes and threads. Patches were proposed, and alternatives solutions
hinted. However, the thread ended with no final solution to the problem.
I would like to bring the problem up again.

The need occurs on Linux installations in which there are some process
control applications,
or some continuous sever applications that need some resilience
towards process failures.
When a process providing an essential service terminates, come
"process monitor" would
create it again, restoring the service automatically (and without the
need for human intervention).
Traditionally this has been implemented in a very inefficient way by
having some process
reading periodically the list of running processes (e.g. by execing
"ps") and checking if the
processes providing essential service are still there.
This is clearly very inefficient, and all the more, it needs to be
executed repeatedly polling
processes.
A much more efficient solution would be for the process monitor to be
allowed to wait
for the termination of any processes/threads belonging to a specified list.
Note that this would mean waiting for one among several events to occur.

Are there any solution to this?

-Angelo Borsotti
