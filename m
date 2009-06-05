Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbZFEQKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbZFEQKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 12:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZFEQJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 12:09:53 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:37303 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964AbZFEQJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 12:09:52 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: linux-kernel@vger.kernel.org
Subject: [Section Mis-match, 2.6.30-rc8] Build generated mis-match message
Date: Fri, 5 Jun 2009 11:09:48 -0500
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906051109.50808.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group,

Anyone have a suggestion about this one:

WARNING: vmlinux.o(.cpuinit.data+0x0): Section mismatch in reference 
  from the variable initial_code to the function .init.text:i386_start_kernel()
The variable __cpuinitdata initial_code references
a function __init i386_start_kernel().
If i386_start_kernel is only used by initial_code then
annotate i386_start_kernel with a matching annotation.

Mike
