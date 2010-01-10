Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356Ab0AJUTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab0AJUTq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 15:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618Ab0AJUTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 15:19:45 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:63928 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab0AJUTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 15:19:45 -0500
Date: Sun, 10 Jan 2010 15:19:26 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: task imap:2958 blocked for more than 120 seconds
Message-ID: <20100110201926.GC32195@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201001102105.47192.johannes.hirte@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001102105.47192.johannes.hirte@fem.tu-ilmenau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B4A365B.0085:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 09:05:46PM +0100, Johannes Hirte wrote:
> I've observed this hanging task now several times. Not sure when this started, 
> but 2.6.32 is affected too, IIRC. I don't have a test pattern for this. Dovecot 
> imap triggers this from time to time. I've enabled CONFIG_DETECT_HUNG_TASK now 
> and got this two tasks which hang:

You're stuck on a read, could you please do a sysrq-w when this happens?
Also, do you eventually recover or are you stuck forever?

-chris
