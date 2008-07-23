Return-Path: <linux-kernel-owner+w=401wt.eu-S1753616AbYGWPmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbYGWPmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 11:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYGWPmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 11:42:03 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:53212 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbYGWPmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 11:42:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=DX6ZeVt6/zyvYqyDLLR6mdMXH3/m6Jsmoz9z2WV4R68EAwLpaw7U0CpYc7NK+0StDn
         /xrrhDxeyM1ZipYpaQ5FVT4O19h8jqAdGwtPIAmo/7fz0IWfb7phuSv+08I3rjNTmudz
         B+9C62Hw1FFKe5Dwg8wcL9OEENav7bYvB76yw=
Message-ID: <9929d2390807230842m410d34fdq8647ce6d7a063a9c@mail.gmail.com>
Date: Wed, 23 Jul 2008 08:42:00 -0700
From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
To: "Will Trives" <will@trivescon.com.au>
Subject: Re: [E1000-devel] kernel crunch to a halt with e1000e driver
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
In-Reply-To: <1216794851.4074.42.camel@Athas>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216794851.4074.42.camel@Athas>
X-Google-Sender-Auth: 6541e0b730de3777
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 11:34 PM, Will Trives <will@trivescon.com.au> wrote:
> Hello guys,
>
> Latest linux git tree, noticed the e1000 driver no longer worked with my
> pci express nic. e1000e works but has the following bug...
>
> Problem: When system grinds to a halt when unplugging the cord from the
> nic.
>
> Let me know if you need any more info.
>
> Kernel Message:
>
> ul 23 15:59:28 Athas eth0: Link is Up 1000 Mbps Full Duplex, Flow
> Control: None
> Jul 23 15:59:28 Athas ------------[ cut here ]------------
> Jul 23 15:59:28 Athas kernel BUG at net/core/dev.c:1328!

This should be fixed in the latest git tree.  Please pull the latest
git tree (Torvalds) and let me know if you still see this issue.

-- 
Cheers,
Jeff
