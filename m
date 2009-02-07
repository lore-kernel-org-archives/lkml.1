Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbZBGXvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbZBGXvA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 18:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbZBGXus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 18:50:48 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:24036 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbZBGXur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 18:50:47 -0500
Subject: Re: [GIT PULL] Btrfs updates for 2.6.29-rc
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0902070837350.3048@localhost.localdomain>
References: <1233937349.17551.18.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0902060851270.3048@localhost.localdomain>
	 <1233957067.10366.0.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0902061358070.3048@localhost.localdomain>
	 <1233965457.10366.11.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0902070837350.3048@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 07 Feb 2009 18:50:01 -0500
Message-Id: <1234050601.19599.13.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.498E1E2C.008A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-07 at 08:37 -0800, Linus Torvalds wrote:
> On Fri, 6 Feb 2009, Chris Mason wrote:
> > 
> > Crud, the confusion would be me.  I missed the cleanups and bug fixes
> > between 2.6.29-rc1 and rc3.   The correct diffstat and short log are
> > below, and the only non-btrfs change is to the MAINTAINERS file.
> 
> Ok.
> 
> I notice that it now asks about ACL's, and says
> 
> 	If you don't know what Access Control Lists are, say N

The text was stolen from ext3, or from someone else that stole it from
ext3....it made sense to me to stay consistent with the others here.
The config option really just provides a way to enable
CONFIG_FS_POSIX_ACL.

The btrfs code only looks for CONFIG_FS_POSIX_ACL, and doesn't have a
special mount -o acl,xattr,security.

-chris


