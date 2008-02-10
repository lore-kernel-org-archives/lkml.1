Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbYBJWAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbYBJWAK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 17:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYBJV74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:59:56 -0500
Received: from fall-curlleaf.atl.sa.earthlink.net ([207.69.195.105]:33278 "EHLO
	fall-curlleaf.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625AbYBJV7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:59:55 -0500
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Feb 2008 16:59:55 EST
Message-ID: <47AF7048.3060200@earthlink.net>
Date: Sun, 10 Feb 2008 16:44:40 -0500
From: Robert Reif <reif@earthlink.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4.2) Gecko/20040308
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Martin Habets <errandir_news@mph.eclipse.co.uk>,
       Adrian Bunk <bunk@kernel.org>, wli@holomorphy.com,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: sparc compile error
References: <20080207231230.GE7198@cs181133002.pp.htv.fi> <alpine.DEB.1.00.0802071538440.15050@chino.kir.corp.google.com> <20080210153355.GA6737@palantir8> <alpine.DEB.1.00.0802101117510.5043@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0802101117510.5043@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:

>Please try Linus' latest git that includes 60c12b12 (from yesterday) that 
>fixes this issue.
>
>  
>
I get this with latest git:

  CC      init/do_mounts.o
In file included from include/linux/mm.h:39,
                 from include/linux/memcontrol.h:24,
                 from include/linux/swap.h:8,
                 from include/linux/suspend.h:7,
                 from init/do_mounts.c:6:
include/asm/pgtable.h:344: warning: parameter names (without types) in 
function declaration
include/asm/pgtable.h:345: warning: parameter names (without types) in 
function declaration
include/asm/pgtable.h:346: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '___f___swp_entry'
make[1]: *** [init/do_mounts.o] Error 1


