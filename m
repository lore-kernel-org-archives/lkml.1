Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbXL1XJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbXL1XJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 18:09:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbXL1XIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 18:08:54 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:10186 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbXL1XIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 18:08:53 -0500
Date: Fri, 28 Dec 2007 15:07:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: KaiGai Kohei <kaigai@ak.jp.nec.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, jmorris@namei.org, akpm@osdl.org,
       morgan@kernel.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Exporting capability code/name pairs
Message-Id: <20071228150733.f70589b3.randy.dunlap@oracle.com>
In-Reply-To: <477494C3.2040301@ak.jp.nec.com>
References: <477321C8.3070004@ak.jp.nec.com>
	<20071227161435.GB9677@sergelap.austin.ibm.com>
	<477455A0.7060603@ak.jp.nec.com>
	<477494C3.2040301@ak.jp.nec.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Dec 2007 15:16:35 +0900 KaiGai Kohei wrote:

> kernel/cap_names.sh generates the body of cap_entries[] array,
> and it is invoked when we make the kernel.
> 
> Signed-off-by: KaiGai Kohei <kaigai@ak.jp.nec.com>
> ---
>  Makefile     |    9 +++++++
>  cap_names.sh |   21 ++++++++++++++++
>  capability.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 105 insertions(+)

Hi,
Please use "diffstat -p 1 -w 70" as suggested in
Documentation/SubmittingPatches so that we can know what
subdirectories those listed file are actually in.

---
~Randy
desserts:  http://www.xenotime.net/linux/recipes/
