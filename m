Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbZHCFdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbZHCFdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 01:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbZHCFdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 01:33:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40013 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbZHCFdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 01:33:08 -0400
Message-ID: <4A76768F.6090800@zytor.com>
Date: Sun, 02 Aug 2009 22:33:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Steffen Winterfeldt <snwint@suse.de>, Sebastian Herbszt <herbszt@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Callback interfaces
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sketching on a callback infrastructure for Syslinux 4.  I'm 
wondering specifically what you would prefer to have hooked.  One option 
is to put hooks into the code for open(), read() and close(); another 
option would be to only invoke hooks from loadfile().

What other hooks would you like to have?

	-hpa
