Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbXJUQX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbXJUQX5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 12:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbXJUQXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 12:23:51 -0400
Received: from mail.musicgenome.com ([212.150.69.147]:55272 "EHLO
	mail.musicgenome.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbXJUQXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 12:23:50 -0400
X-Greylist: delayed 890 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Oct 2007 12:23:49 EDT
Date: Sun, 21 Oct 2007 17:53:37 +0200
From: Tal Kelrich <tal@musicgenome.com>
To: linux-kernel@vger.kernel.org
Subject: 2.4/2.6 local TCP connect oddity
Message-ID: <20071021175337.605e843e@shodan.orpak.com>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.6.10; i686-redhat-linux-gnu)
X-Habeas-SWE-1: winter into spring
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Musicgenome-MailScanner-Information: Please contact the ISP for more information
X-Musicgenome-MailScanner: Found to be clean
X-Musicgenome-MailScanner-SpamCheck: not spam, SpamAssassin (score=-5.899,
	required 6, autolearn=not spam, ALL_TRUSTED -3.30, BAYES_00 -2.60)
X-Musicgenome-MailScanner-From: tal@musicgenome.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've run into a problem where a process trying to connect to a local
port within the local port range eventually ends up connected to itself,
with source port = dest port.

similar behavior can be gotten by running netcat as follows:
nc -p 1025 localhost 1025

I'm not really sure if that's a bug, but the original case was at least
unexpected.

Regards,
	Tal Kelrich

-- 
Tal Kelrich
PGP fingerprint: 3EDF FCC5 60BB 4729 AB2F  CAE6 FEC1 9AAC 12B9 AA69
Key Available at: http://www.hasturkun.com/pub.txt
----
Administration:  An ingenious abstraction in politics, designed to
receive the kicks and cuffs due to the premier or president.
-- Ambrose Bierce
----

