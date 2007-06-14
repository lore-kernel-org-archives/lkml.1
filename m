Return-Path: <linux-kernel-owner+w=401wt.eu-S1753146AbXFNNK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbXFNNK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 09:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbXFNNKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 09:10:17 -0400
Received: from swszl.szkp.uni-miskolc.hu ([193.6.2.24]:39600 "EHLO
	swszl.szkp.uni-miskolc.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbXFNNKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 09:10:15 -0400
X-Greylist: delayed 1090 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2007 09:10:15 EDT
Date: Thu, 14 Jun 2007 14:52:03 +0200
From: Vitez Gabor <vitezg@niif.hu>
To: linux-kernel@vger.kernel.org
Subject: heartbeat problems on linux 2.6.21.[34]
Message-ID: <20070614125203.GV20208@swszl.szkp.uni-miskolc.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm running debian etch in linux 2.6.21.[34], and ran into troubles with
heartbeat:

In some cases, I get "
Jun 12 13:14:36 sf1 heartbeat[2973]: ERROR: No local heartbeat. Forcing restart.
Jun 12 13:14:36 sf1 heartbeat[2973]: WARN: Late heartbeat: Node sf1: interval 42740 ms

"

The heartbeat configuration files were copied from another debian machine,
running 2.6.18-3-xen-686 stock debian kernel, with no problems. 



The machine is not loaded, I'm just testing heartbeat on it.


Other information:
gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)

Third-party modules:
aoe6-47
iSCSI Enterprise Target   latest svn checkout


The machines are Dell poweredge 2650 machines, with 2 GHz Intel Xeon CPUs.

I tried both with NOHZ and high resolution timers enabled and disabled, the
results are the same.


Any suggestions, help would be appreciated.

Please Cc: me back when answering; I'm not subscribed.


        thanks
           Gabor Vitez
