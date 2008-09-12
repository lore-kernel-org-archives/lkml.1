Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbYILKYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbYILKYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 06:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbYILKYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 06:24:40 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:46260 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbYILKYj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 06:24:39 -0400
Date: 12 Sep 2008 12:24:37 +0200
From: kovlensky@interia.pl
Subject: "Invalid module format" after recompiling kernel without changing .config - why?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: TEXT/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-ORIGINATE-IP: 195.224.154.166
IMPORTANCE: Normal
X-MSMAIL-PRIORITY: Normal
X-PRIORITY: 3
X-Mailer: PSE3
Message-Id: <20080912102437.D20AA1082477@f22.poczta.interia.pl>
X-EMID: 6bd40acc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summary for impatient ones - how to extract struct_module data from both kernel and modules to find out what disagreement described below is really about?

Long story - I've got few machines with closed-source modules and urgent need for cutting few things out of stock kernel. As Suse, like every vendor, provides source for their kernel (rpms kernel-source-2.6.16.21-0.8 and kernel-smp-2.6.16.21-0.8 respectively) everything looks simple - installing fresh machine with no updates (SLES10 GA in my case), grabbing .config from /proc/config.gz and make bzImage with no single change should bring me the kernel with is compatible with the shipped one. But it isn't. No single module works after that. Here is what I get after my try:

fat: disagrees about version of symbol struct_module

uname -a is exactly the same. modinfo data are exactly the same. .config is exactly the same. Gcc major version is also the same. But modules from stick kernel still does not load when running recompiled kernel and, after forcing that, they simply crash, so that's not cosmetic complain. So what's going on? Am I missing something here? Is there a way to extract mode data from kernel and modules to check what is this disagreement about struct_module about?

----------------------------------------------------------------------
Drogowa Mapa Polski GPS w Twoim telefonie!
Pobierz >> http://link.interia.pl/f1f0a 

