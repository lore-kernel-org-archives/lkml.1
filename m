Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab0BTSbW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 13:31:22 -0500
Received: from forum.psychotherapie.org ([217.160.22.205]:54983 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753578Ab0BTSbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 13:31:20 -0500
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Feb 2010 13:31:20 EST
Message-ID: <4B802870.5030201@metux.de>
Date: Sat, 20 Feb 2010 19:22:40 +0100
From: Enrico Weigelt <weigelt@metux.de>
Organization: metux IT service
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.23) Gecko/20091124 SeaMonkey/1.1.18
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Dynamic linking in the kernel
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

just some naive thoughts on dynamic linking:

Starting up an dynamically linked executable tends to need a lot
of syscalls. A kernel-based dynamic linker could cache a lot of
relocation data (eg. when the same binary is called many times),
share pages even w/o mmap(), and the ldstub wouldnt be needed
anymore.

At that point we maybe also could create a new binfmt which is
tailored to efficiency (much simpler than ELF)


What do you think about this idea ?


cu
-- 
----------------------------------------------------------------------
 Enrico Weigelt, metux IT service -- http://www.metux.de/

 cellphone: +49 174 7066481   email: info@metux.de   skype: nekrad666
----------------------------------------------------------------------
 Embedded-Linux / Portierung / Opensource-QM / Verteilte Systeme
----------------------------------------------------------------------

