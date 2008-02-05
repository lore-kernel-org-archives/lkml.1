Return-Path: <linux-kernel-owner+w=401wt.eu-S1761537AbYBEUpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761537AbYBEUpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760738AbYBEUpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:45:12 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:49690 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759950AbYBEUpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:45:10 -0500
Date: Tue, 5 Feb 2008 15:45:09 -0500
To: Hasan Rashid <hasan@digitalpath.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CS5536 How to detect a  reset by the WDT?
Message-ID: <20080205204509.GG26259@csclub.uwaterloo.ca>
References: <2048.65.164.104.9.1202244027.squirrel@webmail.digitalpath.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2048.65.164.104.9.1202244027.squirrel@webmail.digitalpath.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 12:40:27PM -0800, Hasan Rashid wrote:
> Does anyone know if there is a way to detect a reset caused by the MFGPT
> WDT in CS5536? I am using the ALiX2c0 boards.

I don't believe there is any way to do that.  Not 100% sure though.
We actually have an I2C M41T81 with battery backed ram to be our main
watchdog so that we can identify when a watchdog trigger occoured on the
system.  Most watchdogs do not provide any state information to the
system after a reset unfortunately.

--
Len Sorensen
