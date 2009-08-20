Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbZHTTNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbZHTTNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 15:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbZHTTNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 15:13:21 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:54197 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbZHTTNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 15:13:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Oc3QW/MzBBfgmlh3Q1iMaf3KlxHtn6TuTALk4kzfo8wr1ZCHKAGZXZfTB5jiMqU7Vb
         17NzTOFiRoWde3KXslC6IkIPsJlirwGPZ6OjAqGcLIghuDDFgVY7F1WXy6IcLS5ger7t
         0armM2a7okDlrJKJnuWYrQXh3VoBa6Za0atY4=
Date: Thu, 20 Aug 2009 23:08:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, q-funk@iki.fi,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [Bug #13941] x86 Geode issue
Message-ID: <20090820190804.GA7271@lenovo>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera> <ADSuNT6McuD.A.R0.COIjKB@chimera> <11fae7c70908200033k7c28561eh28e1195ce4a692f8@mail.gmail.com> <200908201704.06553.rjw@sisk.pl> <20090820183635.GB8517@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090820183635.GB8517@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Thu, Aug 20, 2009 at 10:36:35PM +0400]
...
| | > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13941
| | > > Subject         : x86 Geode issue
| | > > Submitter       : Martin-Éric Racine <q-funk@iki.fi>
| | > > Date            : 2009-08-03 12:58 (17 days old)
| | > > References      : http://marc.info/?l=linux-kernel&m=124930434732481&w=4
| | 
| | Rafael
| | 
| 
| Hi,
| 
| may I post a thought?
| 
| It seems strange to me that alloc_inode may set 
| 
| #ifdef CONFIG_FS_POSIX_ACL
| 	inode->i_acl = inode->i_default_acl = ACL_NOT_CACHED;
| #endif
| 
| [where ACL_NOT_CACHED is #define ACL_NOT_CACHED ((void *)(-1))]
| 
| meanwhile say jffs2_init_acl_post use ACL_NOT_CACHED
| as a valid value and trying to parse it.
| 
| But perhaps, I miss something.
| 
| 	-- Cyrill

Sorry, this is unrelated and wrong. Drop this message.

	-- Cyrill
