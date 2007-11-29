Return-Path: <linux-kernel-owner+w=401wt.eu-S1763575AbXK2Qxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763575AbXK2Qxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761502AbXK2Qxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:53:35 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:48172 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159AbXK2Qxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:53:35 -0500
Date: Thu, 29 Nov 2007 17:53:33 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Greg KH <greg@kroah.com>
cc: Jon Masters <jonathan@jonmasters.org>, Valdis.Kletnieks@vt.edu,
       Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
In-Reply-To: <20071129164746.GB9664@kroah.com>
Message-ID: <Pine.LNX.4.64.0711291752550.13075@fbirervta.pbzchgretzou.qr>
References: <20071128144156.GA14106@infradead.org> <416908.77038.qm@web36613.mail.mud.yahoo.com>
 <20071128164613.GA21815@infradead.org> <25290.1196273705@turing-police.cc.vt.edu>
 <20071128183040.GW8181@ftp.linux.org.uk> <20071129003840.GA22530@kroah.com>
 <Pine.LNX.4.64.0711290152470.22052@fbirervta.pbzchgretzou.qr>
 <20071129010753.GA19106@kroah.com> <1196354172.6473.52.camel@perihelion>
 <20071129164746.GB9664@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 29 2007 08:47, Greg KH wrote:
>On Thu, Nov 29, 2007 at 11:36:12AM -0500, Jon Masters wrote:
>> On Wed, 2007-11-28 at 17:07 -0800, Greg KH wrote:
>> 
>> > The easiest way is as Al described above, just have the userspace
>> > program that wrote the file to disk, check it then.
>> 
>> But the problem is that this isn't just Samba, this is a countless
>> myriad of different applications. And if one of them doesn't support
>> on-access scanning, then the whole solution isn't worth using.
>
>Ok, which specific applications do they care about?  Last time I asked
>it was still limited to a very small handful, all of which would be
>trivial to add such a hook to.
>
Well, think bash, syscalls. While you can add a plugin to samba "easily",
it seems overkill to do the same for rm, mv, cp, bash.

