Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbZGWWEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbZGWWEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 18:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZGWWEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 18:04:14 -0400
Received: from web112314.mail.gq1.yahoo.com ([98.137.26.172]:43117 "HELO
	web112314.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752482AbZGWWEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 18:04:13 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Jul 2009 18:04:13 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=CQieL0+NC0HeRKh5LVEUJ58s8keEBwxMDSoLxsRehHre7Qp7SbM4JOVYURdPCLDIRsEPvkSPYuKlE9d3ikJ9OHBvTGBSMAzY6byBBjyHGovkM2P8PCpKPPc8GxFQedZzp6SOZzLesYDLfibUgYA367KWFrgs5YEm9OFHgXk2WPw=;
Message-ID: <295130.45660.qm@web112314.mail.gq1.yahoo.com>
X-YMail-OSG: AdjBS7kVM1l.XZNGOlWegbYNxSq_GtzYabFXKbaXwGN7O2uJdKp8xhAbTQm6hHXzqRpz5DA5NPMtX82.5On0ONl222EnMjFtovzxEWzWTscY1yIjZt2pg5Sy5fRG2nv6BOHtA8Kv7hiO8Q8PSdLgU.CyeLotmRUPc.DOyhrXe90yai3Cz6wsCevEiyPJ6I_WfDuJOoPJ7nkBJA6HvbPvbBpE4aRkqfHhOtLhi05fA1GsyInVWgAnACot05BJ03NSMRbmTZOOfZ0HGYvukC7qjXtQ9nXk55_HDDwOuRZgwICIY8PQEs0hROk6_fIIWGLPUhLPqa9lXuQ32A--
X-Mailer: YahooMailClassic/6.0.19 YahooMailWebService/0.7.289.15
Date: Thu, 23 Jul 2009 14:57:32 -0700 (PDT)
From: We La <w.landgraf@yahoo.com>
Subject: Assertion pthread_mutex_unlock'&m->mutex) == 0  failed at pulsecore/mutex-posix.c:98
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In the kernels 2.6.31-rcX  many sound / video applications and firefox with youtube, crashs with the following error message:

With exactly the same config and software (unly changing the kernels) this never happened before.  There is no file pulsecore/mutex-posix.c installed in my system.  I suppose this is a problem of changes in any sound driver.

W.Landgraf
Linux SYS



Assertion pthread_mutex_unlock'&m->mutex) == 0  failed at pulsecore/mutex-posix.c:98, function pa_mutex_unlock(). Aborting


===============

root@darkstar:~# lspci
00:00.0 RAM memory: nVidia Corporation MCP61 Memory Controller (rev a1)
00:01.0 ISA bridge: nVidia Corporation MCP61 LPC Bridge (rev a2)
00:01.1 SMBus: nVidia Corporation MCP61 SMBus (rev a2)
00:01.2 RAM memory: nVidia Corporation MCP61 Memory Controller (rev a2)
00:02.0 USB Controller: nVidia Corporation MCP61 USB Controller (rev a2)
00:02.1 USB Controller: nVidia Corporation MCP61 USB Controller (rev a2)
00:04.0 PCI bridge: nVidia Corporation MCP61 PCI bridge (rev a1)
00:05.0 Audio device: nVidia Corporation MCP61 High Definition Audio (rev a2)
00:06.0 IDE interface: nVidia Corporation MCP61 IDE (rev a2)
00:07.0 Bridge: nVidia Corporation MCP61 Ethernet (rev a2)
00:08.0 IDE interface: nVidia Corporation MCP61 SATA Controller (rev a2)
00:09.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev a2)
00:0b.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev a2)
00:0c.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev a2)
00:0d.0 VGA compatible controller: nVidia Corporation GeForce 6100 nForce 405 (rev a2)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
root@darkstar:~#



      
