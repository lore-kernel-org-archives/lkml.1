Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbXLKTs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbXLKTs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 14:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbXLKTsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 14:48:51 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42723 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbXLKTsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 14:48:50 -0500
Date: Tue, 11 Dec 2007 20:48:51 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Anas Nashif <nashif@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Management Engine Interface
Message-ID: <20071211194851.GC21864@one.firstfloor.org>
References: <475EC9C1.9080708@linux.intel.com> <p7363z5nlo8.fsf@bingen.suse.de> <475ED912.609@linux.intel.com> <20071211185317.GA21864@one.firstfloor.org> <475EDFA3.1070001@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475EDFA3.1070001@linux.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually no TCP/IP is needed here. Basically the MEI driver writes and reads the
> messages to/from the firmware. When communicating in-band using LMS, TCP/IP
> terminates at LMS and the messages are copied using MEI driver.

Ah that's good to know. I suspect the SOAP interchange could be stripped
down a lot to make it reasonably simple; ideally with all strings just hardcoded
somewhere. Would much parsing be needed?

-Andi
