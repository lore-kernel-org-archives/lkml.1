Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbYAGJBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbYAGJBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 04:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbYAGJBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 04:01:18 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:20060 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752574AbYAGJBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 04:01:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qUdyqJvEIRjos4fS9D6NS4SnkqcNoViLye/fR3kYzgrqLcnu4KN3K7rKGDx2hT2MB9eF948UX8hLBuCphM2pWecqogKJJCwIT3LWkCCaO9dkRQrgqEtYCfQKum9w+FH/Br96xh8XmnryGQBV4Nz9nXeFisvjIMnTr60RrPpNr7M=  ;
X-YMail-OSG: qli0yroVM1leGxcoJXHL9qEkY.8xTp1KdAkzjd.Hguk96.0XNGS0CQdJa9KFLjwvYo6E3KiErQ--
From: David Brownell <david-b@pacbell.net>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Mon, 7 Jan 2008 01:01:13 -0800
User-Agent: KMail/1.9.6
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, stern@rowland.harvard.edu,
       peterz@infradead.org, davem@davemloft.net, jarkao2@gmail.com,
       krh@redhat.com, dbrownell@users.sourceforge.net,
       James.Bottomley@hansenpartnership.com, a.zummo@towertech.it,
       cbou@mail.ru, dwmw2@infradead.org,
       linux1394-devel@lists.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, linux-scsi@vger.kernel.org,
       rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
References: <20080103055019.GA4885@darkstar.te-china.tietoenator.com> <20080107020944.GA3637@darkstar.te-china.tietoenator.com> <20080107084528.GA8365@suse.de>
In-Reply-To: <20080107084528.GA8365@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801070101.15168.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 January 2008, Greg KH wrote:
> Most of the non-driver core code should be converted to not use the
> lock in the class at all.  They should use a local lock instead.

Or better yet, that yet-to-be-written class_for_each_instance()
iterator ... :)

