Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbYBJKaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbYBJKaE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 05:30:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758090AbYBJK3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 05:29:50 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:33189
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758663AbYBJK3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 05:29:48 -0500
Message-ID: <47AED219.7050106@qumranet.com>
Date: Sun, 10 Feb 2008 12:29:45 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: KVM is not seen under X86 config with latest git (32 bit compile)
References: <20080210071628.GA27409@balbir.in.ibm.com>
In-Reply-To: <20080210071628.GA27409@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> The KVM configuration is no longer visible in the latest git tree. It looks
> like it is selected by HAVE_SETUP_PER_CPU_AREA. I've moved HAVE_KVM to
> under CONFIG_X86. Hopefully, this is the right fix.
>
>   

Yes, this was caused by my misunderstanding of the Kconfig language.

Acked-by: Avi Kivity <avi@qumranet.com>

-- 
error compiling committee.c: too many arguments to function

