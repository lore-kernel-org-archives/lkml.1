Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbYGPBoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbYGPBoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 21:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbYGPBoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 21:44:19 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:37996 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbYGPBoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 21:44:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=iiG85vAA8V8lrDLNAx1l6GU+mcG2LTcqpRMI412zA+EjTDqiBa9l+IHzl3S2VidZDM
         lASzb+UvnWyIQRnIjofWfWeE68WMW9blilIMo2eDaAsWSYxtAA35UpxJNc0UHvHuViy/
         tWosufSqCYJfYDa9WB4SGIe9/Ux+PY0MRzs2s=
Message-ID: <19f34abd0807151844g2cdac2f7x41c2d6832339b434@mail.gmail.com>
Date: Wed, 16 Jul 2008 03:44:18 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: v2.6.26: Bad EIP value at shutdown
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My apologies for the bad report, I just got this when shutting down a
v2.6.26, and with no camera at hand, I wrote down what I could see:

The last line of the stack dump contained the number 0xfee1dead, which
I assume is some kind of magic number.

The stacktrace:

notifier_call_chain
_cpu_down
disable_nonboot_cpus
acpi_clear_gpe_block
kernel_power_off
sys_reboot

Code: Bad EIP value

So a NULL-pointer call.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
