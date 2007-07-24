Return-Path: <linux-kernel-owner+w=401wt.eu-S1761217AbXGXXuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761217AbXGXXuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 19:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756375AbXGXXuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 19:50:11 -0400
Received: from main.gmane.org ([80.91.229.2]:51882 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227AbXGXXuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 19:50:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Steven <hairpinblue@yahoo.com>
Subject: Re: Thinkpad ACPI
Date: Tue, 24 Jul 2007 23:44:46 +0000 (UTC)
Message-ID: <f862td$i6q$1@sea.gmane.org>
References: <20070724.171917.30313741.yoshfuji@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: rrcs-66-27-48-50.west.biz.rr.com
User-Agent: Pan/0.129 (Benson & Hedges Moscow Gold)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007 17:19:17 -0500, YOSHIFUJI Hideaki / 吉藤英明 wrote:

> Linux 2.6.23-rc1 fails to power off my ThinkPad T42. Git-bisect told me
> that the following commit is to blame, and by reverting that commit, it
> works appropriately.

I have noted the same behavior on a Thinkpad 600X.

On the topic of Thinkpad ACPI, the following has occured twice (out of over
one hundred boots) in the last month during boot, once with a 2.6.21.5
kernel and once with 2.6.22.1.

Jul 23 06:51:31 celestial kernel: [ 204.882991] ACPI: Core revision 20070126
Jul 23 06:51:31 celestial kernel: [ 204.947102] ACPI: setting ELCR to 0a00 (from 0800)
Jul 23 06:51:31 celestial kernel: [ 208.791654] ACPI Error (hwacpi-0142): Hardware did not change modes [20070126]
Jul 23 06:51:31 celestial kernel: [ 208.792229] ACPI Error (evxfevnt-0086): Could not transition to ACPI mode [20070126]
Jul 23 06:51:31 celestial kernel: [ 208.792806] ACPI Warning (utxface-0139): AcpiEnable failed [20070126]
Jul 23 06:51:31 celestial kernel: [ 208.793299] ACPI: Unable to enable ACPI

