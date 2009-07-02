Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbZGBOG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbZGBOG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 10:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbZGBOGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 10:06:22 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:31761 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbZGBOGV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 10:06:21 -0400
MIME-Version: 1.0
Message-ID: <87cb4d6e-dbfe-497b-b651-9b912dc3fbc8@default>
Date: Thu, 2 Jul 2009 07:03:46 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Pavel Machek <pavel@ucw.cz>, Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       npiggin@suse.de, chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, Avi Kivity <avi@redhat.com>,
       Rik van Riel <riel@redhat.com>, alan@lxorguk.ukuu.org.uk,
       Rusty Russell <rusty@rustcorp.com.au>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@osdl.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, tmem-devel@oss.oracle.com,
       sunil.mushran@oracle.com, linux-mm@kvack.org,
       Himanshu Raj <rhim@microsoft.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>
Subject: RE: [RFC] transcendent memory for Linux
In-Reply-To: <20090702063813.GA18157@elf.ucw.cz>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.2  (306040) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4A4CBE61.0005:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, OK, I give up.  I will ensure all code for shared pools
is removed from the next version of the patch.

Though for future reference, I am interested in what
problems it has other than "just" security (offlist
if you want).

> -----Original Message-----
> From: Pavel Machek [mailto:pavel@ucw.cz]
> 
> > > Yeah, a shared namespace of accessible objects is an entirely 
> > > new thing
> > > in the Xen universe.  I would also drop Xen support until 
> > > there's a good
> > > security story about how they can be used.
> > 
> > While I agree that the security is not bulletproof, I wonder
> > if this position might be a bit extreme.  Certainly, the NSA
> > should not turn on tmem in a cluster, but that doesn't mean that
> > nobody should be allowed to.  I really suspect that there are
> 
> This has more problems than "just" security, and yes, security should
> be really solved at design time...
> 								
> 			Pavel
