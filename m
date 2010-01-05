Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396Ab0AETdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab0AETdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308Ab0AETdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:33:43 -0500
Received: from kroah.org ([198.145.64.141]:41197 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663Ab0AETdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:33:43 -0500
Date: Tue, 5 Jan 2010 11:26:17 -0800
From: Greg KH <greg@kroah.com>
To: nishimura@mxp.nes.nec.co.jp
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, stable <stable@kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [stable] [BUGFIX][PATCH v3] memcg: avoid oom-killing innocent
 task in case of use_hierarchy
Message-ID: <20100105192617.GA9681@kroah.com>
References: <20091124145759.194cfc9f.nishimura@mxp.nes.nec.co.jp>
 <20091124162854.fb31e81e.nishimura@mxp.nes.nec.co.jp>
 <20091125090050.e366dca5.kamezawa.hiroyu@jp.fujitsu.com>
 <20091125143218.96156a5f.nishimura@mxp.nes.nec.co.jp>
 <20091217094724.15ec3b27.nishimura@mxp.nes.nec.co.jp>
 <20100104222818.GA20708@kroah.com>
 <20100105122633.28738255.d-nishimura@mtf.biglobe.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105122633.28738255.d-nishimura@mtf.biglobe.ne.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 12:26:33PM +0900, Daisuke Nishimura wrote:
> On Mon, 4 Jan 2010 14:28:19 -0800
> Greg KH <greg@kroah.com> wrote:
> 
> > On Thu, Dec 17, 2009 at 09:47:24AM +0900, Daisuke Nishimura wrote:
> > > Stable team.
> > > 
> > > Cay you pick this up for 2.6.32.y(and 2.6.31.y if it will be released) ?
> > > 
> > > This is a for-stable version of a bugfix patch that corresponds to the
> > > upstream commmit d31f56dbf8bafaacb0c617f9a6f137498d5c7aed.
> > 
> > I've applied it to the .32-stable tree, but it does not apply to .31.
> > Care to provide a version of the patch for that kernel if you want it
> > applied there?
> > 
> hmm, strange. I can apply it onto 2.6.31.9. It might conflict with other patches
> in 2.6.31.y queue ?
> Anyway, I've attached the patch that is rebased on 2.6.31.9. Please tell me if you
> have any problem with it.
> 
> v3: rebased on 2.6.31.9

This version worked, thanks for regenerating it.

greg k-h
