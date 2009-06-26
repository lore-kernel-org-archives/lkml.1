Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbZFZOER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbZFZOER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758287AbZFZOEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:04:08 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:35568 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008AbZFZOEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:04:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=gF0fWg1zUMeHISbA9yD7UdhAKfuZwushH1cESOPdzYSN/q949TlzjNaIf8LUUkKFig
         2FctRYVDhlDAAeygWph9KhNNzjn9blQxa+SnyTszZ2c6Vw5IByQzV8emtehPvDXPcw9V
         wUg37VOIILy45hmVwXRXH447MWe0Rh/CXGYjc=
MIME-Version: 1.0
Date: Fri, 26 Jun 2009 16:04:04 +0200
Message-ID: <b08bcbf50906260704s11181158r27d88e2dd518b1e9@mail.gmail.com>
Subject: Kernel hard_start_xmit performance vs SOCK_RAW performance
From: Gallus <gall.cwpl@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
what path would you choose to rapidly generate packets:
1. Develop kernel space module and user space client tool.
The tool would call the module through ioctl() passing the packet
contents. The module would then construct sbk buffer and call
hard_start_xmit.

2. Develop only user space client tool
The tool would just sent packets through raw sockets.


I'm wondering if amount of system calls in (1) solution will not be a problem?

Which path is generally better?

-- 
Regards,
Gallus
