Return-Path: <linux-kernel-owner+w=401wt.eu-S1760407AbYBAL5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760407AbYBAL5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 06:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbYBAL5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 06:57:23 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:33594 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYBAL5W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 06:57:22 -0500
Date: Fri, 01 Feb 2008 12:57:20 +0100
Message-Id: <139824397@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Subject: Linux VM completely lost it`s timesource !?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/Mx+aGgNhfcPzBqPPPz0zo8SJVJerMAwpPBP7uVW+ULvIRz
 2rSIpjKauo33EgDChPBQH126dRT2EprJ80JDv+a+m5xRKYsAgU=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

I`m running 2.6.24 kernel in a recent version of vmware workstation and i`m unsure if i hit a linux issue or a vmware issue here.

after suspend/resume (hibernate) of my physical system (win xp), the linux guest seems to have lost it´s timesource.

don`t know much about timers in linux, so let me explain first:

the guest was running when i suspended the xp host.
the xp host is running fine after resume.
the guest has issues.

triggering a console beep inside the linux VM now doesn`t give a short beep but terrorizing me with a never-ending continuous beep.

seems to be a timer issue inside the guest, since tools like top, vmstat, watch etc don`t work anymore.
the system clock gone crazy, too - it`s counting from 22:40:47 to 22:40:51 and then constantly jumps back to 22:40:47

can someone give an advice what to check to make sure that this is NOT a linux issue ?
i will contact vmware then afterwards.

regards
roland

ps:
i did a snapshot of the VM and could preserve the state of the system this way.
________________________________________________________
Bis 50 MB Dateianhänge? Kein Problem!
http://www.digitaledienste.web.de/freemail/club/lp/?lp=7

