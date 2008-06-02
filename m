Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbYFBRg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbYFBRg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbYFBRgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:36:51 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:59113 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542AbYFBRgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:36:50 -0400
Date: Mon, 2 Jun 2008 13:36:49 -0400
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Cc: devzero@web.de, linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       hmh@hmh.eng.br
Subject: Re: [Bug 10797] Something is consuming power after shutdown
Message-ID: <20080602173649.GE16164@csclub.uwaterloo.ca>
References: <300254332@web.de> <484342B6.7020605@diamondcut.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484342B6.7020605@diamondcut.com.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 09:45:42PM -0300, Renato S. Yamane wrote:
> I don't know why, but as commented in Bug #10797, if I close my LCD
> Display (activing LID), power on again (because when LID is actived, my
> laptop hibernate), and shutdown, my battery charge not is changed.

You must be triggering some combination of ACPI events that happen to do
the right thing on the system.  However if issueing a power off doesn't
turn off the system, then it really sounds broken.

-- 
Len Sorensen
