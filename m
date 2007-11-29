Return-Path: <linux-kernel-owner+w=401wt.eu-S933130AbXK2Tn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130AbXK2Tn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932546AbXK2Tnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:43:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:1337 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400AbXK2Tns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:43:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=fA7iSRhNdn4PxnCvEOFera8vE3tFtO8+ahl+H4YBeuWEFlcqHyQpTQ7n0DlxtO5AyaehWqCYagLprYN/8vjLGtrdiBmoVgm/2sN0pYfCeWHOwHBCN7AHzcX6plXOhXoJ5lLgD1mRHGLhSH6nT35iLeRBLP9eMoQWtiyMXd8r52Q=
Date: Thu, 29 Nov 2007 22:44:23 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: PPCML <linuxppc-dev@ozlabs.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH 0/5] PPC cleanup: do use for_each macro
Message-ID: <20071129194423.GA12123@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cleanup patch set. It does convert for(...)/while(...) cycles
into appropriate for_each_...() macros calls.

The patch set is splitted up in idea to hold changes localy
to a specified platform.

Any comments are welcome.

		Cyrill

