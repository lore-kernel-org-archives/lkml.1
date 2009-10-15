Return-Path: <linux-kernel-owner+w=401wt.eu-S1763235AbZJOWxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763235AbZJOWxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 18:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758769AbZJOWxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 18:53:54 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:59739 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758574AbZJOWxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 18:53:53 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Organization: VMware, Inc.
To: pv-drivers@vmware.com
Subject: Re: [Pv-drivers] [PATCH -next] vmxnet3: use dev_dbg, 
 =?iso-8859-1?q?=09fix_build_for?= CONFIG_BLOCK=n
Date: Thu, 15 Oct 2009 15:53:17 -0700
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc4; KDE/4.3.1; x86_64; ; )
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       David Miller <davem@davemloft.net>
References: <20091015152538.74a1cb15.sfr@canb.auug.org.au> <4AD7A569.1040308@oracle.com> <200910151547.48247.dtor@vmware.com>
In-Reply-To: <200910151547.48247.dtor@vmware.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910151553.17203.dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 October 2009 03:47:48 pm Dmitry Torokhov wrote:
> Hi Randy,
> 
> On Thursday 15 October 2009 03:42:49 pm Randy Dunlap wrote:
> > Bhavesh Davda wrote:
> > > Who ever compiles with CONFIG_BLOCK=n? Just kidding...
> >
> > or why does networking need CONFIG_BLOCK at all?  ;)
> >
> > > Thanks again for making this change! Ship it!
> >
> > So could I have used adapter->netdev->dev or adapter->pdev->dev ?
> > either of them?  are they the same?
> 
> They are the same.
> 

Hmm.. I take this back, adapter->netdev->dev.parent == adapter->pdev->dev.

-- 
Dmitry
