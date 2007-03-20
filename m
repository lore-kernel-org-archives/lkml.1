Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591AbXCTSNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbXCTSNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 14:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbXCTSNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 14:13:10 -0400
Received: from gw.goop.org ([64.81.55.164]:36471 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbXCTSNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 14:13:09 -0400
Message-ID: <460023F1.8060102@goop.org>
Date: Tue, 20 Mar 2007 11:12:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Ravinandan Arakali (rarakali)" <rarakali@cisco.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Multiple instances of program sharing same text segment ?
References: <FA6FB5FA4DA6BF4386D129273B2E3EC30183A437@xmb-sjc-214.amer.cisco.com>
In-Reply-To: <FA6FB5FA4DA6BF4386D129273B2E3EC30183A437@xmb-sjc-214.amer.cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ravinandan Arakali (rarakali) wrote:
> I note that do_exec calls do_mmap to map the executable file to memory.
> But not sure what happens(w.r.t text sharing) when another instance of 
> the program is invoked. BTW, this is 2.6.10.

Yes, they will be shared.  As far as the rest of the kernel is
concerned, an mmap is an mmap is an mmap, and the pages will be shared.

    J
