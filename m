Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbZJBCmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbZJBCmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 22:42:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbZJBCmC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 22:42:02 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55724 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbZJBCmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 22:42:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 2 Oct 2009 11:39:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: No more bits in vm_area_struct's vm_flags.
Message-Id: <20091002113946.172dc982.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091002103755.ba0fbb10.kamezawa.hiroyu@jp.fujitsu.com>
References: <4AB9A0D6.1090004@crca.org.au>
	<20090924100518.78df6b93.kamezawa.hiroyu@jp.fujitsu.com>
	<4ABC80B0.5010100@crca.org.au>
	<20090925174009.79778649.kamezawa.hiroyu@jp.fujitsu.com>
	<4AC0234F.2080808@crca.org.au>
	<20090928120450.c2d8a4e2.kamezawa.hiroyu@jp.fujitsu.com>
	<20090928033624.GA11191@localhost>
	<20090928125705.6656e8c5.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0909281637160.25798@sister.anvils>
	<a0ea21a7cfe313202e2b51510aa5435a.squirrel@webmail-b.css.fujitsu.com>
	<Pine.LNX.4.64.0909282134100.11529@sister.anvils>
	<20090929105735.06eea1ee.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0910011238190.10994@sister.anvils>
	<20091002094238.6e1a1e5a.kamezawa.hiroyu@jp.fujitsu.com>
	<20091002103755.ba0fbb10.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Oct 2009 10:37:55 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> This one
> ==
> #define FLAG    (0x20)
> 
> int foo(unsigned long long x)
> {
>         if (x & ~FLAG)
>                 return 1;
>         return 0;
> }
> 
Then, !!(x & ~FLAG) is necessary...i see (>_<
Maybe no problem..

Thanks,
-Kame

