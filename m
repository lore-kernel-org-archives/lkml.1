Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbYJ1QSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbYJ1QSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYJ1QSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:18:38 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:53448 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbYJ1QSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:18:37 -0400
Date: Tue, 28 Oct 2008 14:19:16 -0200
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: snd-hda-intel prevents machine to power off
Message-ID: <20081028141916.610a2847@doriath.conectiva>
In-Reply-To: <s5hskqgbt4h.wl%tiwai@suse.de>
References: <20081028135933.36778d60@doriath.conectiva>
	<s5hskqgbt4h.wl%tiwai@suse.de>
Organization: Mandriva
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 28 Oct 2008 17:07:42 +0100
Takashi Iwai <tiwai@suse.de> escreveu:

| >  Hi Takashi,
| > 
| >  If I have some process with the sound device opened in my eeepc
| > (say KDE's kmix) and try to power off the machine, for example with:
| > 
| > # echo o > /proc/sysrq-trigger
| > 
| >  The machine will not power off.
| 
| At which point does it stop?
| What shows alt-sysrq-t (or w) output?

 I'm wondering how to get that kind of output because everything
is disabled at that point (display inclusive).

| >  But it does work if I remove the snd-hda-intel module before issuing
| > the echo above.
| > 
| >  This problem seems to be pretty popular among distros, I could find
| > it reported for Mandriva, Ubuntu and Fedora.
| 
| Hmm, I haven't heard of unfixed issues.

 Well, these are the tickets I've found:

https://bugzilla.redhat.com/show_bug.cgi?id=444115
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/126140
https://qa.mandriva.com/show_bug.cgi?id=44752

| >  Its workaround is also documented in a few wikis: people are doing
| > a 'rmmod snd-hda-intel' in the last halt stage (ie, halt script
| > in etc).
| 
| I hate wiki or forum just recommending a wrong workaround :)

 Yeah.

-- 
Luiz Fernando N. Capitulino
