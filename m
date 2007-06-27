Return-Path: <linux-kernel-owner+w=401wt.eu-S1763521AbXF0Wnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763521AbXF0Wnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 18:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759618AbXF0Wnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 18:43:43 -0400
Received: from web30508.mail.mud.yahoo.com ([68.142.200.121]:42359 "HELO
	web30508.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751250AbXF0Wnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 18:43:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=fcoy4cGn0rfHFmmEH1eWW15T6qbjPk9WcjeEn9TmJzUwphwjv03FoBSAxsHYhY+aVKD4kY2WBvMyBxNfzYFjpy/xYyHBpfcicDjpeNzi+ecnXhthHc737XT5fhKRCdB4xHYkto1Kw8Mh0oTpIzA4adPCII4K0j/4btTUIo2YJx8=  ;
Message-ID: <20070627224342.44393.qmail@web30508.mail.mud.yahoo.com>
X-YMail-OSG: dlHSsUQVM1lJHUTo4d0XnVEzJvRyGsgiEVenHrGV807MRN9qemM80FtRnzGQ7IUn6hWtepLK7g--
Date: Wed, 27 Jun 2007 15:43:42 -0700 (PDT)
From: Casey Leedom <casey_leedom@yahoo.com>
Subject: Re: ZERO_PAGE() vs. loadable modules in Redhat 4.4 i386 kernels ...
To: linux-kernel@vger.kernel.org
In-Reply-To: <159834.25233.qm@web30515.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Nevermind.  I realized I was being an idiot.  Sorry for the wasted bandwidth.

  Basically, if we have a page that get_user_pages() returned to us, the only
way any part of the PGD/PUD/PMD maping hierarchy can be missing is if the page
is the ZERO_PAGE().  Thus I can use this to detect my ZERO_PAGE() failure mode.

  Thanks for your help!

Casey
