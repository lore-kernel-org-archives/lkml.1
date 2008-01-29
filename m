Return-Path: <linux-kernel-owner+w=401wt.eu-S1762599AbYA2NIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762599AbYA2NIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762208AbYA2NIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:08:12 -0500
Received: from michael.checkpoint.com ([194.29.32.68]:63472 "EHLO
	michael.checkpoint.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761818AbYA2NIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:08:11 -0500
Message-ID: <479F2543.40705@checkpoint.com>
Date: Tue, 29 Jan 2008 15:08:19 +0200
From: Yoav Artzi <yoavar@checkpoint.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Sending IOCTLs from 32-bit userland to 64-bit Kernel module
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I have a 32-bit user land application which sends an IOCTL to a 64-bit 
Kernel module. I have a few different cmd codes that I can send through 
the IOCTL. For some reason I seem to always get the same IOCTL cmd from 
user land, no matter what the ioctl() call is given. This cmd code that 
I get has some bytes (W/R and the module code) that are OK, but the rest 
is just garbage or zeros. This was originally a 32-bit system, and we 
are no converting the Kernel module to 64-bit, so maybe there's 
something special for 32-64 communication that miss.


I am working on Linux Kernel v2.6.18.


Thanks


