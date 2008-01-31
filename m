Return-Path: <linux-kernel-owner+w=401wt.eu-S1763647AbYAaUxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763647AbYAaUxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 15:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbYAaUxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 15:53:31 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:37523 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751592AbYAaUxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 15:53:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CIteYUCn6hR2cBnym0RJkpnfRuE+udaCLe30y1q2dahItf1cWDmEa48FDKIbzS/nfc59KN/2XxHNTMdapyPqQyn1PTt5HXxgXcR1HvVwC2XZW66ZCZeog76Oyg0wDA8feOt5BQJbvYfxTtd2OVqjiJl8xXjNSfUow0qx6Gy0wWQ=  ;
X-YMail-OSG: qPQWPTQVM1kGRbnRFi9kloTRMIPp0eVA5gdiITVsg3tgxqtlX5qBl1G1CQ3_p1KE3_MzSnF25g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: spi-devel-general@lists.sourceforge.net
Subject: Re: [spi-devel-general] [PATCH 0/6] [Blackfin] SPI driver updates
Date: Thu, 31 Jan 2008 12:50:46 -0800
User-Agent: KMail/1.9.6
Cc: Bryan Wu <bryan.wu@analog.com>, linux-kernel@vger.kernel.org
References: <1201684421-26124-1-git-send-email-bryan.wu@analog.com>
In-Reply-To: <1201684421-26124-1-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801311250.46415.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've forwarded these to Andrew, with my signoff and updated comments.
You still need to work on having your patch descriptions match up
to what the patches actually do...

Patches 3-5 in this series seem to have a common thread:  waiting
until BIT_STAT_SPIF is set before moving to the next step of the
transfer.  Next time something similar happens, I'd rather see just
one patch addressing the issue on all code paths ... not three small
patches that only fix it for a few of the code paths.

Also, two of those three patches describe their updates as fixing
a "regression", or "reverting" the code.  Was this a bug that came
in those patches you wanted to merge to 2.6.24?  If so, shouldn't
those regression fixes go into the stable series?

- Dave

