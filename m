Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbXDHHmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbXDHHmD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 03:42:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbXDHHmC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 03:42:02 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:47184 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752674AbXDHHmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 03:42:00 -0400
Message-ID: <46189CC6.2070004@gmail.com>
Date: Sun, 08 Apr 2007 09:41:58 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: "S. Vishnu Priya" <vpriya@lantana.tenet.res.in>
Cc: linux-kernel@vger.kernel.org
Subject: Re: pci card detection by kernel
References: <Pine.LNX.4.64.0704081051270.26389@lantana.tenet.res.in>
In-Reply-To: <Pine.LNX.4.64.0704081051270.26389@lantana.tenet.res.in>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

S. Vishnu Priya napsal(a):
> 
> Dear All,
> 
>       I am new to this group. I was asked to write a device driver for a
> new pci card. My doubt is, Kernel will detect a new pci card which is
> attached to the system? Or how we can make the kernel to detect the new
> card which is newly attached? I am using kernel 2.6.11.12. Please
> suggest me regarding this.

See drivers/*, search for pci_driver -- driver, probe, remove, suspend, resume
and pci_device_id table.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
