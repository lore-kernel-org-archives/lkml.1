Return-Path: <linux-kernel-owner+w=401wt.eu-S1755801AbYLIXF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbYLIXF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 18:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbYLIXFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 18:05:17 -0500
Received: from outbound-mail-125.bluehost.com ([67.222.38.25]:45923 "HELO
	outbound-mail-125.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751696AbYLIXFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 18:05:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=cwU/pQL0rqc2EkBfoF3i3jbL/FTc22TrsTTRXwqQcjOkZLL4LbhUXxG9k0/G7uZ7DCsV+zJBLZQ1Sc8rXc139THTP5LVRS66nZjthtCzsUz7K9INsXZno4npFJnfELiU;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: PCI fix
Date: Tue, 9 Dec 2008 15:04:39 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200812091441.14250.jbarnes@virtuousgeek.org>
In-Reply-To: <200812091441.14250.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812091504.40126.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 216.239.45.19 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 09, 2008 2:41 pm Jesse Barnes wrote:
> Please pull my for-linus branch:
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git
> for-linus
>
> One more last minute fix for a small memory leak from Alex.

Urg, added one more patch after sending this:

Thomas Renninger (1):
      PCIe: ASPM: Break out of endless loop waiting for PCI config bits to 
switch

 drivers/pci/pcie/aspm.c |   29 ++++++++++++++++++++++++++---

Sorry about that.

-- 
Jesse Barnes, Intel Open Source Technology Center
