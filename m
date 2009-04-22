Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbZDVHiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbZDVHiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 03:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZDVHil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 03:38:41 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:34842 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZDVHik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 03:38:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=kzA7Tvr/ugcvf+6tzF7cwbr89pAvYKEGXF3U5R23Jt7+CGAPLCwRNlcZTKIfsyvgeL
         h7/oVqKGlH9A8ni8Vi/qg/RjXU20hYJmMN7lNhTt5GZkd9HY9zp4GMhJnDNc1Dh/LCF2
         h+910OLTHa7nEOZ8O8eoCxJ0K//29lmIMx5pA=
Date: Wed, 22 Apr 2009 09:38:33 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.30_rc1] powernow-k8: oops during initialization
Message-ID: <20090422073833.GA23936@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>,
	linux-kernel@vger.kernel.org
References: <49E7175D.6060808@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49E7175D.6060808@pardus.org.tr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Apr 16, 2009 at 02:32:45PM +0300, Ozan Çağlayan wrote:

> [    4.085400] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 4800+ processors (2 cpu cores) (version 2.20.00)
> [    4.103978] ------------[ cut here ]------------
> [    4.122674] WARNING: at arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1257 powernowk8_cpu_init+0x487/0x994()
> [    4.142059] Hardware name: Unknow

> [    4.161164] [Firmware Bug]: powernow-k8: Your BIOS does not provide ACPI _PSS objects in a way that Linux understands. Please report this to the Linux ACPI maintainers and complain to your BIOS vendor.

Just read what the message says: it is not a kernel bug but simply your
BIOS is missing the _PSS objects on which powernow-k8 relies. I'm pretty
sure you had similar message in earlier kernels but it was a simple
warning then.

Is it possible to upgrade your BIOS? If you're lucky, it might've been
fixed :).

-- 
Regards/Gruss,
    Boris.
