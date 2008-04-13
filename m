Return-Path: <linux-kernel-owner+w=401wt.eu-S1758694AbYDMNGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694AbYDMNGI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 09:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbYDMNF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 09:05:56 -0400
Received: from smtp2web.tin.it ([212.216.176.236]:54433 "EHLO smtp2web.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319AbYDMNF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 09:05:56 -0400
Message-ID: <11947e44e7e.d.capitella@tin.it>
Date: Sun, 13 Apr 2008 14:05:54 +0100 (GMT+01:00)
From: "d.capitella@tin.it" <d.capitella@tin.it>
Reply-To: "d.capitella@tin.it" <d.capitella@tin.it>
To: linux-kernel@vger.kernel.org
Subject: Implementing a Linux Security Module
Mime-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: 90.131.250.240
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there! I'm studying the Linux Security Module Framework, and I'm
experiencing some issues while trying to register the modules I create.

I created a basic test module that just registers itself as a lsm. I
tried to load it on many distros, Ubuntu, Fedora, RedHat but it is not
allowed to register. 

May this be due to other LSMs that doesn't 
support stacking and that are
already loaded on those distros? If 
that's the problem, can't we just
create a security module that does 
nothing but managing the stacking of
other security modules?

Thanks,
Donato Capitella
