Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbZGFVad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbZGFVad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 17:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZGFVaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 17:30:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54899 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbZGFVaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 17:30:25 -0400
Message-ID: <4A526CE6.30200@zytor.com>
Date: Mon, 06 Jul 2009 14:30:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: John Gregor <john.gregor@qlogic.com>
CC: linux-kernel@vger.kernel.org, John Gregor <johng@diamond.mv.qlogic.com>,
       Ralph Campbell <ralph.campbell@qlogic.com>
Subject: Re: [PATCH] x86_64/__iowrite32_copy: don't use string move for PIO
 writes
References: <1246907224-22758-1-git-send-email-john.gregor@qlogic.com>
In-Reply-To: <1246907224-22758-1-git-send-email-john.gregor@qlogic.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Gregor wrote:
> From: John Gregor <johng@diamond.mv.qlogic.com>
> 
> Some processors can write the same word more than once if the movs
> instruction is used. This version uses normal memory move instructions
> and gets the same performance since the speed is limited by PCIe and
> write combining.
> 

Which processors do that *when addressing I/O memory*?

	-hpa
