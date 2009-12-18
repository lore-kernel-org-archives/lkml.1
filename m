Return-Path: <linux-kernel-owner+w=401wt.eu-S932260AbZLRRar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbZLRRar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbZLRRap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:30:45 -0500
Received: from pmx1.sophos.com ([213.31.172.16]:51795 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbZLRRap convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:30:45 -0500
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: linux-kernel@vger.kernel.org, mhiramat@redhat.com,
       linux-kbuild@vger.kernel.org
Subject: Build error with 2.6.33-rc1
Date: Fri, 18 Dec 2009 17:30:42 +0000
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Message-Id: <200912181730.42693.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 18/12/2009 17:30:42,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 18/12/2009 17:30:43,
	Serialize complete at 18/12/2009 17:30:43
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

There is first thiw warning about gawk, and then the failure. Not sure if they 
are related. This build system has mawk installed (Ubuntu 8.10).

Error: Your awk doesn't support charactor-class.
Please try to use gawk.
  CC      arch/x86/lib/inat.o
arch/x86/lib/inat.c:24:25: error: inat-tables.c: No such file or directory
arch/x86/lib/inat.c: In function ‘inat_get_opcode_attribute’:
arch/x86/lib/inat.c:29: error: ‘inat_primary_table’ undeclared (first use in 
this function)
arch/x86/lib/inat.c:29: error: (Each undeclared identifier is reported only 
once
arch/x86/lib/inat.c:29: error: for each function it appears in.)
arch/x86/lib/inat.c: In function ‘inat_get_escape_attribute’:
arch/x86/lib/inat.c:44: error: ‘inat_escape_tables’ undeclared (first use in 
this function)
arch/x86/lib/inat.c: In function ‘inat_get_group_attribute’:
arch/x86/lib/inat.c:67: error: ‘inat_group_tables’ undeclared (first use in 
this function)
arch/x86/lib/inat.c: In function ‘inat_get_avx_attribute’:
arch/x86/lib/inat.c:85: error: ‘inat_avx_tables’ undeclared (first use in this 
function)
make[1]: *** [arch/x86/lib/inat.o] Error 1
make: *** [arch/x86/lib] Error 2
