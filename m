Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbZJNGmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbZJNGmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbZJNGmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:42:20 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:59273 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbZJNGmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:42:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Z7NorJzod7ZAM3xBKF9FkI7Mk0UmyFwZ0TbmCsd5/cG76HIjTsvFEIrLXqItgH+NgK
         8slDES/5xvwyqukPUKOB/6tIxJkYL4/X2vEFl1uiCHd3mbxoAeDa1SwGj6bGpKDcE3YQ
         L6Y6tgB5mFDD9D1FdYgGOv4eYE7Tea9ltIHQc=
MIME-Version: 1.0
Date: Tue, 13 Oct 2009 23:36:01 -0700
Message-ID: <f22d86810910132336r1d6f6363qa983b355676dc413@mail.gmail.com>
Subject: How to check whether executing in atomic context?
From: "Leonidas ." <leonidas137@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi List,

I am working on a profiler kind of module, the exported apis of my
module can be
called from process context and interrupt context as well. Depending on the
context I am called in, I need to call sleepable/nonsleepable variants
of my internal
bookkeeping functions.

I am aware of in_interrupt() call which can be used to check current
context and take action
accordingly.

Is there any api which can help figure out whether we are executing
while hold a spinlock? I.e
an api which can help figure out sleepable/nonsleepable context? If it
is not there, what can
be done for writing the same? Any pointers will be helpful.

-Leo.
