Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbZCFFcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbZCFFcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 00:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbZCFFcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 00:32:21 -0500
Received: from ns2.suse.de ([195.135.220.15]:34040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbZCFFcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 00:32:20 -0500
From: Neil Brown <neilb@suse.de>
To: martin f krafft <madduck@debian.org>
Date: Fri, 6 Mar 2009 16:32:09 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18864.46425.242906.213929@notabene.brown>
Cc: Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Future of md multipath
In-Reply-To: message from martin f krafft on Thursday March 5
References: <20090303180433.GA27569@lst.de>
	<18863.15828.150450.275712@notabene.brown>
	<20090305130017.GA1696@piper.oerlikon.madduck.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday March 5, madduck@debian.org wrote:
> also sprach Neil Brown <neilb@suse.de> [2009.03.05.0349 +0100]:
> > I'm in favour of deprecating it.  Whenever I hear of people using it I
> > suggest dm-multipath, but there could people I don't here about.
> > I think the upcoming mdadm-3.0 will need a compile-time option to
> > enable multipath, so people will only get it if they really really
> > want it.
> 
> How do you propose a distro to deal with this? Keep it enabled for
> a certain time (with a deprecation warning?) and then just to close
> the doors on users who still need it?
> 
> How long will you support it after deprecation?
> 
> I understand that dm-multipath is more favourable, but unless
> there's a riskless way to convert mdadm multipath into dm-multipath
> on old systems, I don't think we have the option of deprecating it,
> unless deprecation lasts for several years.

Always the practical one, aren't you :-)

I wonder how hard it would be to get mdadm to assemble a multipath
using the 'dm' code rather than the 'md' code....
Or to get the md layer in the kernel to hook in to the dm multipath
implementation.

I think it is probably worth putting in a printk now to say "You
should probably be using dm-multipath".  But we probably do need to
leave the code there for a while longer..

NeilBrown
