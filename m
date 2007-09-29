Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbXI2BL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbXI2BL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 21:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbXI2BLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 21:11:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44100 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbXI2BLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 21:11:19 -0400
Message-ID: <46FDA634.3030900@zytor.com>
Date: Fri, 28 Sep 2007 18:11:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: regression in 2.6.23-rc8 - power off failed on old laptop
References: <20070929010351.GA4768@erig.dyndns.org>
In-Reply-To: <20070929010351.GA4768@erig.dyndns.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfgang Erig wrote:
> Hi,
> 
> the latest kernel does not power off my old laptop.
> 
> 2.6.22 succeeded
> 2.6.23-rc8 failed
> 
> $ git bisect good 
> Bisecting: 0 revisions left to test after this 
> [626073132b381684c4983e0d911e9aceb32e2cbc] Assembly header and main routine for new x86 setup code 
> 
> Which more info is needed?
> 

A description of the system, your .config file, kernel messages (old and
new).

Also see http://marc.info/?i=46FD802D.2030804@zytor.com for a highly
useful debugging step, especially if you can dump both before & after.

	-hpa
