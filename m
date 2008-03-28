Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbYC1Wr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbYC1Wr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 18:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbYC1Wq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 18:46:56 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58413 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755059AbYC1Wq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 18:46:56 -0400
Message-ID: <47ED755E.1000103@garzik.org>
Date: Fri, 28 Mar 2008 18:46:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Luis Sousa <ls.luis_sousa@yahoo.com.br>
CC: linux-kernel@vger.kernel.org
Subject: Re: sata io freeze, 2.6.18 and also 2.6.24
References: <739784.81690.qm@web46009.mail.sp1.yahoo.com>
In-Reply-To: <739784.81690.qm@web46009.mail.sp1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis Sousa wrote:
> I've been having consistent hard system freezes for a
> long time, every 2 days or so, and finally decided to
> move to the most recent stable kernel. Unfortunatelly
> that didn't fix it. The freezes seem to be io-related;
> they started since I moved my drive to sata. They seem
> to happen mostly when there's an io-intensive operation,
> like extracting a big archive; a reboot is needed.

We need more info, namely full 'dmesg', 'lspci -v', and your kernel config.

Also, make /sure/ you are not running closed-source modules known to 
crash the system, like ndiswrapper or nvidia graphics driver.

	Jeff



