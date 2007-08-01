Return-Path: <linux-kernel-owner+w=401wt.eu-S934281AbXHAPHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934281AbXHAPHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932525AbXHAPGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:06:54 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51963 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426AbXHAPGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:06:51 -0400
From: Bob Nelson <rrnelson@linux.vnet.ibm.com>
To: oprofile-list@lists.sourceforge.net,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22 new perfmon code base + libpfm + pfmon
Date: Wed, 1 Aug 2007 10:09:10 -0500
User-Agent: KMail/1.9.7
References: <20070726140222.GA7852@frankl.hpl.hp.com> <200708010922.41551.rrnelson@linux.vnet.ibm.com>
In-Reply-To: <200708010922.41551.rrnelson@linux.vnet.ibm.com>
Cc: eranian@hpl.hp.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708011009.10761.rrnelson@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 August 2007 09:22:41 am Bob Nelson wrote:

> It looks to me like you were saying you would remove this extension to the
> OProfile file system (/dev/oprofile/implementation).
> However, it looks like it has made it into the mainline kernel code.  As David
> pointed out, the value isn't initialized for architectures other than i386.  As
> a result you get a kernel crash (at least on PPC) with the following commands.
> 
> opcontrol --init
> cat /dev/oprofile/implementation
> 
> Kevin Corry is working on a patch but until that makes it out people may want
> to be a little careful with this...
> 
My misunderstanding.  We wound up with the older version of the patch in our
version of the kernel.  It looks like the offending code was removed from the
later version of the patch.

Bob


