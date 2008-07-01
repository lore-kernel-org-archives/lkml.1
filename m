Return-Path: <linux-kernel-owner+w=401wt.eu-S1760587AbYGAQU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587AbYGAQU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 12:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbYGAQUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 12:20:20 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52808 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYGAQUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 12:20:19 -0400
Date: Tue, 1 Jul 2008 18:20:17 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: sam@ravnborg.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux fatal: cannot describe <sha1>
Message-ID: <alpine.LNX.1.10.0807011817230.20393@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Just a note that when you run git-describe, you should probably quiten it.

fatal: cannot describe 'bd7364a0fd5a4a2878fe4a224be1b142a4e6698e'

This happens when tags are not present, which can happen if Linus's tree 
is sent upwards again, IOW:

 machine1$  git-clone torvalds/linux-2.6.git
 machine1$  git push elsewhere master

 machine2$  git-clone elsewhere:/linux
 machine2$  git-describe HEAD
 fatal: cannot describe that
