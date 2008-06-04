Return-Path: <linux-kernel-owner+w=401wt.eu-S1760033AbYFDN6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbYFDN6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYFDN6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:58:13 -0400
Received: from po-out-1718.google.com ([72.14.252.156]:2284 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbYFDN6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:58:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=H+HVm726VqCCmKK19qqLk3P2R7q8pQqtxdspslPvR7J8xdYGXusGuPrR6b6rSxqFIE
         YuMXClS4srDX/tE3Igy8QO1eI9gtcXfG3r5pQNRA669JH0jIpwSEm+cyKFBMNxNCL9zQ
         esMP3jcGl4MGD69l7wZwfR9TYlFPXIDmuhKgA=
Message-ID: <961aa3350806040658s1efbeecdi6e9eee15c59edda2@mail.gmail.com>
Date: Wed, 4 Jun 2008 22:58:08 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [PATCH 2/2] bluetooth: hci_bcsp.c small cleanups/api users
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Marcel Holtmann" <marcel@holtmann.org>
In-Reply-To: <1212517161.11008.60.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1212517161.11008.60.camel@brick>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/4 Harvey Harrison <harvey.harrison@gmail.com>:
> Use bitrev16 from lib/bitrev.c.

Please add "select CONFIG_BITREVERSE" in Kconfig when config
option BT_HCIUART_BCSP is enabled.
