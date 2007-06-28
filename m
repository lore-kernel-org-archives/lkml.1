Return-Path: <linux-kernel-owner+w=401wt.eu-S1765224AbXF1TFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765224AbXF1TFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 15:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762962AbXF1TFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 15:05:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:7420 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbXF1TE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 15:04:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=KcoGLGHwvyvFdunnJRg8uqL/ZZQB6XK730gNSl3M92p0jOeET4HarMAJQxe2tqqvI1jGiGc8l645eUxdpWM2d6qoYUUaHUXs9a6mzUxvTq7+mwqt8xo3uL7kg+TwOhNNwPP1XFl/oCqtdDlAoXdf9GpWCfuCOP26nTdjayqivOk=
Date: Thu, 28 Jun 2007 23:05:03 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: James Morris <jmorris@namei.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] security: move mmap_min_addr sysctl to /proc/sys/vm
Message-ID: <20070628190503.GA5803@martell.zuzino.mipt.ru>
References: <20070622203822.GA22807@linux-os.sc.intel.com> <20070628001221.364438ce.akpm@linux-foundation.org> <20070628012749.caf450f6.akpm@linux-foundation.org> <Line.LNX.4.64.0706281139010.13114@localhost.localdomain> <Line.LNX.4.64.0706281140530.13114@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0706281140530.13114@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 11:41:38AM -0400, James Morris wrote:
> Move mmap_min_addr sysctl to /proc/sys/vm, as suggested by Andrew Morton.

Probably too late, since it's userspace visible. Everyone using
/proc/sys/kernel/mmap_min_addr in scrips will be surprised.

