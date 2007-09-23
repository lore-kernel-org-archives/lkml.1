Return-Path: <linux-kernel-owner+w=401wt.eu-S1757258AbXIWSAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbXIWSAr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 14:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755328AbXIWSAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 14:00:40 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:64833 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbXIWSAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 14:00:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=sEiQ9CeOyjoPVWarT7wopNq2QUccwvabheTUVFguWotep3pZdyfGLRnUo8N7N+jH/IeeqCM/3EHahQPKqSlQWTYwEw8T8ZO9GuOSOjr5ANZSWPvFz/CYT7mbozVLNEuTijbzp6KWLWYGlDwctdWMjQ5Wtys0gKlrHejKVwL3awY=
Date: Sun, 23 Sep 2007 19:58:21 +0200
From: Diego Calleja <diegocg@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Urgent bugzilla mainteinance needed
Message-Id: <20070923195821.cab02f42.diegocg@gmail.com>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Take a look at http://bugzilla.kernel.org/show_bug.cgi?id=3710

bugzilla tries to send a mail to the reporter, it fails ("unknown user account"),
but the error failure is appended as a bugzilla comment. Then bugzilla tries to
send that comment to everyone involved in the bug, including the reporter,
so it fails again.....Houston, we've a endless loop.

There're 540 comments in that bug report already, and the bugme-daemon
mail list is being spammed....
