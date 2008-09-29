Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbYI2GvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbYI2GvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 02:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbYI2GvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 02:51:06 -0400
Received: from elasmtp-spurfowl.atl.sa.earthlink.net ([209.86.89.66]:43663
	"EHLO elasmtp-spurfowl.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801AbYI2GvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 02:51:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=teleport.com;
  b=WsPXhdhofHw8E5u80ayAOD7JxoKf1xzPXHve1elqboqK5OBROfVz5T7ytH0c6QHw;
  h=Message-ID:Date:From:Reply-To:To:Subject:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Message-ID: <31134782.1222671063829.JavaMail.root@elwamui-mouette.atl.sa.earthlink.net>
Date: Sun, 28 Sep 2008 23:51:03 -0700 (GMT-07:00)
From: Alan Young <ayoung@teleport.com>
Reply-To: Alan Young <ayoung@teleport.com>
To: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [kernel-abi] symbol versioning vs. out-of-tree modules.
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: EarthLink Zoo Mail 1.0
X-ELNK-Trace: d1a1f54f9acf59c5c1b8efd72c01d9e49001757d58ee4b9d8a5bc6fb3a131f0b3514e6857a044e10350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 209.86.224.41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008 at 05:10:07 +0200, Greg KH wrote:

> What kernel modules do you currently use/rely on that are not in the
> main kernel tree?  Do you have links to them?  I'd be glad to add them.

I still use the ES56-PI modem driver @ http://tx.technion.ac.il/~raindel.
It has a 2.6 port up to 2.6.24, but it's not more current than that due to
serial/tty interface changes.  And there's a challenge that it uses a binary
blob. :-(  Best case would be to see if the vendor could open up like
Atheros (Thanks! Yea!) did.  If not, I wonder if the blob could be minimalized
to the bare modem functions and the serial interfaces be brought out into open code.

Alan
