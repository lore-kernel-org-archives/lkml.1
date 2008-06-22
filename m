Return-Path: <linux-kernel-owner+w=401wt.eu-S1756013AbYFVTqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbYFVTqn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbYFVTqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:46:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43144 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbYFVTqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:46:35 -0400
Date: Sun, 22 Jun 2008 21:46:32 +0200
From: Bernhard Walle <bwalle@suse.de>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: kexec@lists.infradead.org, x86@kernel.org, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com
Subject: Re: [PATCH 3/3] Limit E820 map when a user-defined memory map is
 specified
Message-ID: <20080622214632.4a140069@kopernikus.site>
In-Reply-To: <86802c440806201334s30cbc685se44326812841fdd2@mail.gmail.com>
References: <1213977420-1555-1-git-send-email-bwalle@suse.de>
	<1213977420-1555-4-git-send-email-bwalle@suse.de>
	<86802c440806201334s30cbc685se44326812841fdd2@mail.gmail.com>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i686-pc-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* "Yinghai Lu" <yhlu.kernel@gmail.com> [2008-06-20 13:34]:
>
> On Fri, Jun 20, 2008 at 8:57 AM, Bernhard Walle <bwalle@suse.de> wrote:
> > This patch brings back limiting of the E820 map when a user-defined
> > E820 map is specified. While the behaviour of i386 (32 bit) was to limit
> > the E820 map (and /proc/iomem), the behaviour of x86-64 (64 bit) was not to
> > limit.
> 
> then if you kexec new kernel, the second kernel will be have that
> limitation too.
> 
> any problem that you encountered without this patch?

No, because the new kexec tool uses the /proc/firmware_mem or whatever
it is called.



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
