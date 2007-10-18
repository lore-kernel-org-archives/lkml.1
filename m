Return-Path: <linux-kernel-owner+w=401wt.eu-S932895AbXJRTUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895AbXJRTUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 15:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758083AbXJRTUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 15:20:17 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:55735 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757850AbXJRTUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 15:20:15 -0400
Date: Thu, 18 Oct 2007 12:14:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: <kmpark@infradead.org>
Cc: "'lkml'" <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
       <dwmw2@infradead.org>
Subject: Re: onenand_sim crashes
Message-Id: <20071018121454.97c0769b.randy.dunlap@oracle.com>
In-Reply-To: <002d01c81084$60fb7980$e1ac580a@swcenter.sec.samsung.co.kr>
References: <20071016221525.307c8904.randy.dunlap@oracle.com>
	<002d01c81084$60fb7980$e1ac580a@swcenter.sec.samsung.co.kr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 15:10:03 +0900 Kyungmin Park wrote:

> Hi,
> 
> Thank you for point out.
> There is a bug. It frees the static variable.
> 
> Please see the attached patch.

Confirm that fixes the problem.  Thanks.

---
~Randy
