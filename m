Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbYDBQDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbYDBQDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbYDBQDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:03:37 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:29623 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755023AbYDBQDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:03:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=hcCkFcJ+/Z0C2oJkHyP56/LJuL7RvKZy4oKWjhxJXS4yv1WHj80/3qx/0rxAXqnYjhyDOihahPHB6A4gs/Da1tgPzPV9BBkUvmV3COU9v0tfr7io9FoInkz3TXY/kipV9rXDLSnjF+qEhFU04M0KXMpRHD+NeGkRrGW0EPkZsRE=  ;
X-YMail-OSG: 8BtoZuYVM1kY0w2.1kOPqC9Q.eAeXmXJ6Ni.LPkrTJ1zvPhXHwPIsKqPbnmcJYrSV2rf8fx4dA--
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 02 Apr 2008 09:04:14 -0700
From: David Brownell <david-b@pacbell.net>
To: stern@rowland.harvard.edu, lkml@rtr.ca
Subject: Re: 2.6.25-rc7:  Ugh.
Cc: pavel@suse.cz, oliver@neukum.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, jikos@suse.cz, gregkh@suse.de,
       akpm@linux-foundation.org
References: <Pine.LNX.4.44L0.0804021106320.6272-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0804021106320.6272-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080402160414.25F3035F5F8@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, check out the thread on LKML started by Tino Keitel.  He had
> similar problems and found that reverting commit
> e82cc1288fa57857c6af8c57f3d07096d4bcd9d9 fixed them.

And try the change I suggested there:  taking the
HC_IS_RUNNING test out of ehci_iaa_watchdog().

