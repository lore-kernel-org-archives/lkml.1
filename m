Return-Path: <linux-kernel-owner+w=401wt.eu-S1759424AbYCGFts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424AbYCGFts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 00:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYCGFtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 00:49:36 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:9182 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbYCGFtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 00:49:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=AWleQohYWz7WA5Ozk2PPjB0jhTLgrqse53QBg2Sp/+nULFFeDZGhWVlsAOAmFhKUVnb3oJdS21VQkByx4ppoTUAG9VJss8oYiQ/XsE4IOrCAoDvlpxv4oeewDxgz9/eF7auM5XHI6ohpFShWKUHaS49jp1vdWBh5Ic5mmKlCki8=
Message-ID: <804dabb00803062149q18063751vad1b8c754a22a85d@mail.gmail.com>
Date: Fri, 7 Mar 2008 13:49:35 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: What is the difference between kernel_thread() and kthread_create()?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Documentation/feature-removal-schedule.txt,
kernel_thread() is supposed to be replaced by kthread_create().   I
saw a few patches doing these.  Seemingly, NO DIFFERENCE, just replace
the kernel_thread() with kthread_create(), but sometimes it replace it
with kthread_run() instead (thin wrapper around kthread_create())
Still not quite sure why yet.

But more fundamental is the file init/main.c:   which have a
kernel_thread() to create the first init task.   Only a few
kernel_thread() API left, mostly exotic architecture.   But this
central figure does not get replaced - is there a reason for it?   So
question is - is there any difference between kernel_thread() and
kthread_create() in the context of init/main.c?

-- 
Regards,
Peter Teoh
