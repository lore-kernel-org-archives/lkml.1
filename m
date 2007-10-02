Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbXJBWbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbXJBWbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 18:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbXJBWa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 18:30:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbXJBWaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 18:30:55 -0400
Message-ID: <4702C694.10402@redhat.com>
Date: Tue, 02 Oct 2007 18:30:44 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Neil Romig <neil@romig.demon.co.uk>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: File corruption when using kernels 2.6.18+
References: <46FFC371.9040805@romig.demon.co.uk>
In-Reply-To: <46FFC371.9040805@romig.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2007 11:40 AM, Neil Romig wrote:
> I am using kernel 2.6.17.14, and would like to use newer versions for
> the wireless code but I get file corruption with any kernel more recent
> than this. My system uses a SiS645DX chipset (it is a rebadged CLEVO
> D400E) with 5513 IDE.
> 
> I get this corruption with read/writes, i.e using "cp", "dd", when
> compiling software, writing to CD, etc etc. An example:
> 
> cp ../Changelog-2.6.18 .
> diff Changelog-2.6.18 ../Changelog-2.6.18
> 
> 16377c16377
> <       LD      .top_vmlinux1
> ---
>>       LD      .tmp_vmlinux1
> 23954c23954
> < Date:   Mon Jul 1% 04:45:11 2006 -0700
> ---
>> Date:   Mon Jul 10 04:45:11 2006 -0700

Is there some pattern to the corruption, like maybe it occurs once every
N bytes in the file?

