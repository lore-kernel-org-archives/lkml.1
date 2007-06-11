Return-Path: <linux-kernel-owner+w=401wt.eu-S1753273AbXFKNNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbXFKNNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 09:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbXFKNNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 09:13:16 -0400
Received: from mail.gmx.net ([213.165.64.20]:41493 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751491AbXFKNNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 09:13:15 -0400
X-Authenticated: #19095397
X-Provags-ID: V01U2FsdGVkX1+xHhIT0ZyxCoN89aLO0LBR2sxYoJd0mPhFzfzT7V
	S60Wmr5r3nuM1y
From: Bernd Schubert <bernd-schubert@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: API changes / 2.6.21 sysctl changes
Date: Mon, 11 Jun 2007 15:13:12 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706111513.12998.bernd-schubert@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

in 2.6.21 register_sysctl_table(), struct ctl_table and probably something 
else did change. Unfortunately so far I didn't figure out the "something 
else". 

Please, if generic interface modifications render all available documentation 
in the web invalid, is it so hard to also write kernel api documentation then 
(even if it so far does not exist in the Documentation/ dir)?

I mean the time overhead of thousands of coders digging through git commits is 
huge, just because API changes are not properly documented.

E.g.: Documentation/api/sysctl.txt

Up to 2.6.20:
struct ctl_table_header *register_sysctl_table(ctl_table * table, int 
insert_at_head);


Beginning with 2.6.21-rcX:
struct ctl_table_header *register_sysctl_table(ctl_table * table);

struct ctl_table:
	removed entry struct proc_dir_entry *de
	added entry ctl_table *parent

[Maybe also something like]

Additionaly to different functions calls, programmers also need to change ...


Thanks,
Bernd


Thanks,
Bernd
