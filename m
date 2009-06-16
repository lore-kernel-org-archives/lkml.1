Return-Path: <linux-kernel-owner+w=401wt.eu-S1759142AbZFPVsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142AbZFPVsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZFPVsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:48:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:60571 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbZFPVsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:48:06 -0400
Message-Id: <65AA39D9-57A3-465E-847A-B1058783F370@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Ability to force the physical location of a kmalloc for testing purposes
Date: Tue, 16 Jun 2009 16:48:05 -0500
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are trying to test some IO DMA code and want to make sure the  
physical address is in a given range for testing.  For example on  
PPC32 w/have 36-bit physical and some of IO devices are capable of  
DMAing to the full 36-bit address.  However we want to test things  
like making sure a physical address >4G works properly.

- k
