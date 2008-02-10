Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbYBJSvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbYBJSvj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 13:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYBJSvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 13:51:31 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:33044 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbYBJSvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 13:51:31 -0500
Date: Sun, 10 Feb 2008 19:51:29 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: sam@ravnborg.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Faster way to run through building single modules
Message-ID: <Pine.LNX.4.64.0802101950020.7915@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I was wondering whether there is a shortcut in kbuild I can take if I 
just want to rebuild one module. Currently, I have:

make net/bridge/netfilter/ebtables.ko

the modpost stage ("MODPOST 2018 modules") does quite a lot of disk I/O, 
most of which I probably do not need anyway. Can this task be sped up?

