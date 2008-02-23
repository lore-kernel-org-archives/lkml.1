Return-Path: <linux-kernel-owner+w=401wt.eu-S1758961AbYBWQyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbYBWQyf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 11:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYBWQyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 11:54:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:50478 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbYBWQyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 11:54:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:sender;
        b=Ig9xwaKq04wbJPw4ORidwT9In+iDv7pW6b40rt5Kw2f8Y0K4JpHWaIb2yeFCsWdVtIzb3I/WIaktV+pj6pyyJ9u5R0YWKCb4o9mZxQg+ziEgDlmuqrZN0GT82Yd/W4Stf5Pc4zfZaSZWf2s/q/Ypq3XoRPN9sgh9KdMGJoKffgU=
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: paulmck@linux.vnet.ibm.com
Subject: Re: 2.6.25-rc2 rcupreempt WARN after suspend to ram
Date: Sat, 23 Feb 2008 17:54:01 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
References: <200802231341.02597.fzu@wemgehoertderstaat.de> <20080223155241.GA12351@linux.vnet.ibm.com>
In-Reply-To: <20080223155241.GA12351@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802231754.01681.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 23. Februar 2008 schrieb Paul E. McKenney:
> On Sat, Feb 23, 2008 at 01:41:02PM +0100, Karsten Wiese wrote:
> > Hi,
> > 
> > This appeared in dmesg after
> > 	$ echo core > /sys/power/pm_test
> > followed by 3 cycles of
> > 	$ echo mem > /sys/power/state
> > . .config attached.
> > 
> > dmesg excerpt (, full ~1MByte available):
> 
> Does this tree have http://lkml.org/lkml/2008/1/29/208 applied?

Yes. This tree was linus' git head as of yesterday or the day before.

Thanks,
      Karsten
