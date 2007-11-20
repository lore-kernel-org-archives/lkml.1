Return-Path: <linux-kernel-owner+w=401wt.eu-S1761146AbXKTSOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761146AbXKTSOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbXKTSOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:14:32 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:36792 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbXKTSOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:14:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=qU+PU11FA86s2+cCySDDMEIZWIPRxkiWG8HtpMOsNGFbCrKo1rA2qNzz0sPdbPHFLmhxRtd4F50ziHu7ppJp7QeCkVSQsT4mNxuUX8FoHjF2D+Qq4oKx8PIfbffI/8B+d18N8sYdOQWLmnvwdv+KDidgNgBGS22POyXOWIoGlwE=
Date: Tue, 20 Nov 2007 12:14:21 -0600
From: Josh Boyer <jwboyer@gmail.com>
To: Jochen Friedrich <jochen@scram.de>
Cc: linuxppc-embedded@ozlabs.org, paulus@samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: Change _tlbie arguments to reflect new API
Message-ID: <20071120121421.5f20c2c6@weaponx>
In-Reply-To: <47431799.6010802@scram.de>
References: <47431799.6010802@scram.de>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; powerpc-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 18:21:29 +0100
Jochen Friedrich <jochen@scram.de> wrote:

> A new pid argument has been added to _tlbie for 4xx platforms.
> Add this argument to the 8xx path in mem.c, as well. As 8xx
> does not need th epid information, this argument can always be 0.

This is already fixed in Paul's tree.

josh
