Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbZEUQrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbZEUQrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbZEUQrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:47:04 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:35146 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbZEUQrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:47:03 -0400
Message-ID: <4A1585AA.9010002@oracle.com>
Date: Thu, 21 May 2009 09:47:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ian Campbell <ian.campbell@citrix.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Becky Bruce <beckyb@kernel.crashing.org>, Olaf Kirch <okir@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       xen-devel <xendevel@lists.xensource.com>,
       x86 maintainers <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       Tony Breeds <tony@bakeyournoodle.com>
Subject: Re: swiotlb: remove __weak hooks in favour of architecture-specific
 functions
References: <1242906335.22654.188.camel@zakaz.uk.xensource.com> <1242922528-5982-1-git-send-email-ian.campbell@citrix.com>
In-Reply-To: <1242922528-5982-1-git-send-email-ian.campbell@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010206.4A158516.0090:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> At the end of this series there are no more __weak functions in
> lib/swiotlb.c
> 
> The series adds several hook functions to the x86 architecture. Would
> they be preferred as a struct x86_swiotlb_ops or as individual hooks?
> 
> I was unsure what to do about powerpc in most places since the
> existing support seems to in-progress so it wasn't always clear where
> to put the implementation. If there is a tree somewhere with more
> complete support I'll be happy to provide additional patches.
> 
> Boot tested on x86 under xen but not even compiled for ia64 or
> powerpc. If someone can point me to a decent source of cross compilers
> I can sort that out. (http://www.kernel.org/pub/tools/crosstool/ seems
> to be out-of-date and only has ia64 in any case)

Try these.  They are fairly current.  I have used several of them.

http://bakeyournoodle.com/cross/

-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
