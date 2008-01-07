Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbYAGRs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbYAGRs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 12:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbYAGRsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 12:48:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33112 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952AbYAGRsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 12:48:50 -0500
Message-ID: <478264CA.5090300@zytor.com>
Date: Mon, 07 Jan 2008 09:43:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: vgoyal@redhat.com, hbabu@us.ibm.com, lkml <linux-kernel@vger.kernel.org>,
       kexec@lists.infradead.org
Subject: Re: kexec refuses to boot latest -mm
References: <20071228124532.GB32643@linux.vnet.ibm.com>
In-Reply-To: <20071228124532.GB32643@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dhaval Giani wrote:
> Hi Vivek,
> 
> I can't seem to get the latest -mm (2.6.24-rc6-mm1) to boot with
> kexec. It just gets stuck at "Starting new kernel".
> 
> It does boot normally when booted as the first kernel.
> 
> Any hints debugging? (x86 architecture)
> 

Hi Dhaval,

Could you give more details of your setup?  I'm trying to figure out 
exactly what it is in kexec that goes goofy, but there seems to be an 
enormous number of codepaths, all different, depending on things like 
which kind of kernel.  The more closely I can replicate your failure, 
the quicker I should be able to locate the problem.

	-hpa
