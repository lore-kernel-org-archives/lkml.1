Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbZKKPsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbZKKPsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 10:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756348AbZKKPsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 10:48:50 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:53032 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753125AbZKKPsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 10:48:50 -0500
Message-Id: <1257954535.18468.1344702051@webmail.messagingengine.com>
X-Sasl-Enc: 1XW7eUZyIIOZnWVNJo6lBtrdjAa8HDhZNgnQzdrIAaZe 1257954535
From: myuboot@fastmail.fm
To: "Gaye Abdoulaye Walsimou" <walsimou@walsimou.com>
Cc: linux-kernel@vger.kernel.org, "linux-mips" <linux-mips@linux-mips.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
References: <1255735395.30097.1340523469@webmail.messagingengine.com>
 <4AD906D8.3020404@caviumnetworks.com>
 <1257898975.30125.1344591929@webmail.messagingengine.com>
 <4AFA6B7F.10404@walsimou.com>
Subject: Re: Kernel panic - not syncing: Attempted to kill init!
In-Reply-To: <4AFA6B7F.10404@walsimou.com>
Date: Wed, 11 Nov 2009 09:48:55 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 11 Nov 2009 08:45 +0100, "Gaye Abdoulaye Walsimou"
<walsimou@walsimou.com> wrote:
> myuboot@fastmail.fm wrote:
> > Hi, 
> >
> > I got the following error trying to bring up the /sbin/init with Kernel
> > 2.6.31 using cramfs filesystem on a MIPS 32 board:
> >   
> 
> Just to be sure does:
> $file vmlinux
> $file busybox
> give the same result?
> 
> Regards
The file result looks ok. The readelf result looks fine too.

file linux-2.6.31/vmlinux root/bin/busybox
linux-2.6.31/vmlinux: ELF 32-bit MSB executable, MIPS, MIPS32 version 1
(SYSV), statically linked, not stripped
root/bin/busybox:     setuid ELF 32-bit MSB executable, MIPS, MIPS32
version 1 (SYSV), dynamically linked (uses shared libs), stripped

Thanks, Andrew
