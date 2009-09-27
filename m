Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbZI0TrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbZI0TrJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 15:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbZI0TrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 15:47:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:8030 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbZI0TrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 15:47:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=s9p43WvRuDsc1PUYIKN29jS4vooVij78/SRyUUxIlnPyy76vYQ2U2RBW3bx+gv71sf
         DT9EK/+LckifLhXvThEuHrraF67DIhJUy0qjR1v+daWQ2vD2wM+CL6v9J+xLq9x+Ctqf
         P+xGe9gidkclWSdzFN/lalCN9gddZK7HqUPoQ=
MIME-Version: 1.0
Date: Sun, 27 Sep 2009 21:47:10 +0200
Message-ID: <f6ca9fed0909271247k7fad64b1g1c4c65544196d7ac@mail.gmail.com>
Subject: sched regression introduced by NO_NEW_FAIR_SLEEPERS
From: drago01 <drago01@gmail.com>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: mingo@redhat.com, Chuck Ebbert <cebbert@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Chuck has backported some scheduler patches from 2.6.32 to the fedora kernel.

I did the following test to test the new scheduler (cpu is a core i7
920 4 cores + HT).

run 8 "md5sum /dev/urandom" task and try to use the desktop (compiz).

The result was that moving windows or rotating the cube is very slow.
(same happens with pure metacity but is is worse in compiz).

Mounting debugfs and doing "echo NEW_FAIR_SLEEPERS > sched_features"
results into a useable desktop while the 8 md5sum tasks are running
(ie. the system behaves as if they where not running at all from an
interactivity pov).


P.S: please CC me when replying.
