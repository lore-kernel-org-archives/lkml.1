Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbYFLBnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbYFLBnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 21:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYFLBm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 21:42:56 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:53457
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbYFLBmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 21:42:55 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Tim Bird <tim.bird@am.sony.com>
Subject: Re: mainlining min-configs...
Date: Wed, 11 Jun 2008 20:42:49 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
References: <48447615.5050806@am.sony.com> <20080611193639.GB2958@cs181133002.pp.htv.fi> <48502BAF.7060209@am.sony.com>
In-Reply-To: <48502BAF.7060209@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806112042.50852.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2008 14:46:55 Tim Bird wrote:
> Adrian Bunk wrote:
> > Randy's patch that documents KCONFIG_ALLCONFIG is in Linus' tree since
> > April 2006.
>
> Well, dangit there it is!
>
> The patch I googled had it going into Documentation/kbuild.  It
> somehow escaped my attention in the README.

Mine as well.  (I grepped for KCONFIG_ALLCONFIG in Documentation, not in the 
rest of the tree.  I of all people should know better...)

> If I was 
> a little more skilled with my grep-ing I would have found it.
> Sorry for the bother!

The linux kernel has documentation in Documentation, in the "make htmldocs" 
output, in the Kconfig help entries, in README files, in the output of "make 
help", and several other places.  (And then there's all the stuff that's not 
_in_ the kernel tarball...)

It's easy to miss.

Rob

P.S: yes, README files plural.
  find . -name "*[Rr][Ee][Aa][Dd][Mm][Ee]*" | grep -v Documentation | wc
  69	69	2315

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
