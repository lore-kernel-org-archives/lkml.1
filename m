Return-Path: <linux-kernel-owner+w=401wt.eu-S1752311AbYJ0AZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbYJ0AZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 20:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYJ0AZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 20:25:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33791 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYJ0AZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 20:25:12 -0400
Message-ID: <49050995.4080508@zytor.com>
Date: Sun, 26 Oct 2008 17:21:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: "Diego M. Vadell" <dvadell@linuxclusters.com.ar>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PAT and MTRRs
References: <200810262246.21807.dvadell@linuxclusters.com.ar> <20081026171210.7b3b096a@infradead.org>
In-Reply-To: <20081026171210.7b3b096a@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> 
> PAT can't make memory cachable that the MTRR's have as uncachable.
> What PAT *can* do is, within an MTRR, do fine grained mapping...
> 

Now, if it wasn't for the braindamage called ACPI and SMM, we could have 
   cleared the MTRR settings and just used PAT...

	-hpa
