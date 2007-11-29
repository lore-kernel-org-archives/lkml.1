Return-Path: <linux-kernel-owner+w=401wt.eu-S1762967AbXK2Q5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762967AbXK2Q5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758399AbXK2Q5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:57:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38537 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757600AbXK2Q5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:57:42 -0500
Date: Thu, 29 Nov 2007 16:57:31 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Greg KH <greg@kroah.com>, Jon Masters <jonathan@jonmasters.org>,
       Valdis.Kletnieks@vt.edu, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
Message-ID: <20071129165731.GA30719@infradead.org>
References: <416908.77038.qm@web36613.mail.mud.yahoo.com> <20071128164613.GA21815@infradead.org> <25290.1196273705@turing-police.cc.vt.edu> <20071128183040.GW8181@ftp.linux.org.uk> <20071129003840.GA22530@kroah.com> <Pine.LNX.4.64.0711290152470.22052@fbirervta.pbzchgretzou.qr> <20071129010753.GA19106@kroah.com> <1196354172.6473.52.camel@perihelion> <20071129164746.GB9664@kroah.com> <Pine.LNX.4.64.0711291752550.13075@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711291752550.13075@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 05:53:33PM +0100, Jan Engelhardt wrote:
> >> But the problem is that this isn't just Samba, this is a countless
> >> myriad of different applications. And if one of them doesn't support
> >> on-access scanning, then the whole solution isn't worth using.
> >
> >Ok, which specific applications do they care about?  Last time I asked
> >it was still limited to a very small handful, all of which would be
> >trivial to add such a hook to.
> >
> Well, think bash, syscalls. While you can add a plugin to samba "easily",
> it seems overkill to do the same for rm, mv, cp, bash.

Can we please stop this useless discussion?  Trying to check the content
of files to see whether they might be malicious is inherently braindead,
and no amounts of plugins in random places will fix this.

