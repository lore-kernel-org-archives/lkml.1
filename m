Return-Path: <linux-kernel-owner+w=401wt.eu-S1758182AbZDGPxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182AbZDGPxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756971AbZDGPw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:52:57 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:19713 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbZDGPw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:52:56 -0400
Message-ID: <49DB769B.7010203@oracle.com>
Date: Tue, 07 Apr 2009 08:51:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-04-07-01-06 uploaded (serial/8250_pci & kernel/sysctl)
References: <200904070812.n378CCnZ030736@imap1.linux-foundation.org>
In-Reply-To: <200904070812.n378CCnZ030736@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.49DB7695.0094:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-04-07-01-06 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git
> 
> It contains the following patches against 2.6.29:


some kind of patch/diff problem here:

drivers/serial/8250_pci.c:

static int
<<<<<<< HEAD:drivers/serial/8250_pci.c
pci_ni8430_setup(struct serial_private *priv,
		 const struct pciserial_board *board,
=======
pci_ni8430_setup(struct serial_private *priv, struct pciserial_board *board,
>>>>>>> FETCH_HEAD:drivers/serial/8250_pci.c
		 struct uart_port *port, int idx)
{


and here:

kernel/sysctl.c:

static int zero;
<<<<<<< HEAD:kernel/sysctl.c
static int __maybe_unused one = 1;
static int __maybe_unused two = 2;
=======
static int two = 2;
>>>>>>> FETCH_HEAD:kernel/sysctl.c
static unsigned long one_ul = 1;
static int one_hundred = 100;
static int one_thousand = 1000;

-- 
~Randy
