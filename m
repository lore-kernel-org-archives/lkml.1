Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbXKFVSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbXKFVSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 16:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755260AbXKFVSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 16:18:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682AbXKFVSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 16:18:40 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jeremy@goop.org, avi@qumranet.com, aliguori@us.ibm.com,
       kvm-devel@lists.sourceforge.net, hollisb@us.ibm.com
Subject: KVM paravirt clocksource - Take 3 out of <put your number here>
Date: Tue,  6 Nov 2007 20:18:53 -0200
Message-Id: <11943875362987-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a new version of kvm paravirt clock implementation

This time, the clockevents part was completely wiped out.
Not that I'm dropping it: As said in my last message, I'm starting
to take the path of having a specialized irq chip, as for avi-san's
suggestion.

However, last iteration made clocksources and clockevents a lot more
independent, and so, turning it into a clocksource-only implementation
was just a matter of deleting code - that can be later added almost as-is.
It also favours people willing to use the clocksource, but going towards
userspace HPET emulation, or things like this.

The goal is to have this part included independently of the other bits.

>From last release:

* no more clockevents (for a while, hang on!)
* per-vcpu hv_clock area, which led to...
* no more purely tsc timing.

If you have a new concern with this version, or I failed to address a previous concern of yours, just voice it!


