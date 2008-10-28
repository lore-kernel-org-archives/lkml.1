Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbYJ1P7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbYJ1P7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 11:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbYJ1P64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 11:58:56 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:41455 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbYJ1P64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 11:58:56 -0400
Date: Tue, 28 Oct 2008 13:59:33 -0200
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: tiwai@suse.de
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: snd-hda-intel prevents machine to power off
Message-ID: <20081028135933.36778d60@doriath.conectiva>
Organization: Mandriva
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 Hi Takashi,

 If I have some process with the sound device opened in my eeepc
(say KDE's kmix) and try to power off the machine, for example with:

# echo o > /proc/sysrq-trigger

 The machine will not power off.

 But it does work if I remove the snd-hda-intel module before issuing
the echo above.

 This problem seems to be pretty popular among distros, I could find
it reported for Mandriva, Ubuntu and Fedora.

 Its workaround is also documented in a few wikis: people are doing
a 'rmmod snd-hda-intel' in the last halt stage (ie, halt script
in etc).

 I have tested with 2.6.27.4 and latest 2.7.28-rc2.

 How I can I help you to debug this?

 Thanks.

-- 
Luiz Fernando N. Capitulino
