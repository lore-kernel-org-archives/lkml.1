Return-Path: <linux-kernel-owner+w=401wt.eu-S1764973AbXHIXoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764973AbXHIXoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 19:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbXHIXoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 19:44:13 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53706 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755595AbXHIXoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 19:44:12 -0400
Message-ID: <46BBA310.6060706@vmware.com>
Date: Thu, 09 Aug 2007 16:28:16 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Gabriel Barazer <gabriel@oxeva.fr>, Andi Kleen <ak@suse.de>,
       Jim Mattson <jmattson@vmware.com>, linux-kernel@vger.kernel.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: 2.6.22 x86_64 : kernel initial decompression hangs on vmware
References: <46A7E606.4030001@oxeva.fr> <46B4A7E4.4030907@vmware.com> <46BB7FCC.4040509@qumranet.com>
In-Reply-To: <46BB7FCC.4040509@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>
> We haven't seen any issue with the 2.6.22 boot decompressor.  Which of 
> the four (fs, gs, ldt, or tr) were proving problematic and why?

It was tr that was affecting Workstation, since we boot through normal 
BIOS path, and only a 16-bit task was loaded at this point.

Just to make the state comprehensive, I opted to reload everything.

Zach
