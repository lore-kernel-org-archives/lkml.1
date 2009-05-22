Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbZEVQDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbZEVQDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 12:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbZEVQDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 12:03:14 -0400
Received: from xenotime.net ([72.52.64.118]:48291 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753349AbZEVQDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 12:03:14 -0400
Message-ID: <4A16CD5A.9050806@xenotime.net>
Date: Fri, 22 May 2009 09:05:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: linux-next: Tree for May 22 (staging/)
References: <20090522185110.3f95b03e.sfr@canb.auug.org.au>
In-Reply-To: <20090522185110.3f95b03e.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090521:


Saw these build warnings on x86_64:

drivers/staging/agnx/pci.c:64:3: warning: "/*" within comment
drivers/staging/agnx/pci.c:223:2: warning: "/*" within comment

drivers/staging/slicoss/slicoss.c:1875:warning: unused variable 'failure'
drivers/staging/stlc45xx/stlc45xx.c:2240: warning: 'struct ieee80211_if_conf' declared inside parameter list
drivers/staging/stlc45xx/stlc45xx.c:2240: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/staging/stlc45xx/stlc45xx.c:2248: error: dereferencing pointer to incomplete type
drivers/staging/stlc45xx/stlc45xx.c:2248: error: dereferencing pointer to incomplete type
drivers/staging/stlc45xx/stlc45xx.c:2360: error: unknown field 'config_interface' specified in initializer
drivers/staging/stlc45xx/stlc45xx.c:2522: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'long unsigned int'
drivers/staging/stlc45xx/stlc45xx.c:2524: warning: format '%x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
drivers/staging/stlc45xx/stlc45xx.c:2524: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'long unsigned int'

drivers/staging/rt3070/common/../../rt2870/common/../../rt2860/common/spectrum.c:1577: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
drivers/staging/rt3070/../rt2870/../rt2860/rt_linux.c:841: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'



There are also 2 outstanding patches for comedi build failures that need to
be applied so that more work can be done on comedi....

-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
