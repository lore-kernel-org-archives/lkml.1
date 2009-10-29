Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109AbZJ2PIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbZJ2PIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 11:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbZJ2PI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 11:08:28 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:51398 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbZJ2PI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 11:08:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=mVUf/OPm18R8u8BmDvu+wKfLjpfX92ogIGddIu8zZSOVPsOXKlrpFo7dYEqXAlbqM7
         HGQAsNNd6MigEnaGDeQlTLt0Rm5Tbd0FzRXtvQkUa8undbqn9gJMiFzeeYqUWW3zL2ZM
         Qycou5cZuG04034NfOTMPFEyBEZYtFLtMh56E=
MIME-Version: 1.0
Date: Thu, 29 Oct 2009 20:38:31 +0530
Message-ID: <292693080910290808x69f25f6fgc49cb646c1c00466@mail.gmail.com>
Subject: Questions about linux scheduler
From: Daniel Rodrick <daniel.rodrick@gmail.com>
To: Linux Newbie <linux-newbie@vger.kernel.org>,
       Kernel Newbies <kernelnewbies@nl.linux.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I'm following the Robert Love's book and am trying to understand the
Linux O(1) scheduler. So here is my understanding. The kernel allows
the applications to specify two types of priorities

* Realtime Priorities: Range from 0 to 99
* Non-realtime priorities: Also called "nice" values range from -20 to +19.

(The above are mutually exclusive)


Over all Scheduling algo
=================
* A total of 140 priorities (100 RT + 40 non-RT) - these priorities
are static - do not change over time.
* A lower priority process will run only if there are no runnable
processes in priority above it - this automatically means that all RT
processes get to run before non-RT processes.
 * tasks on the same priority level are scheduled round robin

Is my above understanding correct? Where my understanding doesn't fit
is the conncept of dynamic timeslice calculation. IMHO, the dynamic
timeslice calculation applies only to Non-RT processes, right? Because
a higher priority RT process should always get to run.

Thanks,

Dan
