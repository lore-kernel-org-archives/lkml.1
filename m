Return-Path: <linux-kernel-owner+w=401wt.eu-S1758384AbYHCSMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384AbYHCSMR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 14:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYHCSMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 14:12:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33284 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751789AbYHCSMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 14:12:00 -0400
Date: Sun, 3 Aug 2008 18:54:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: sukadev@us.ibm.com
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@osdl.org>, serue@us.ibm.com, matthltc@us.ibm.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: Per-instance devpts
Message-ID: <20080803185433.7cfedccb@lxorguk.ukuu.org.uk>
In-Reply-To: <20080803174646.GA20254@us.ibm.com>
References: <20080412172933.GA19295@us.ibm.com>
	<1208027215.28187.17.camel@x61.ebiederm.org>
	<48935205.3090807@zytor.com>
	<20080803050800.GA4322@us.ibm.com>
	<20080803130439.743ff0ae@lxorguk.ukuu.org.uk>
	<20080803174646.GA20254@us.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If /dev/pts/1 is the controlling terminal and there are multiple mounts
> of devpts, when we open /dev/tty, kernel would somehow have to find the
> right instance of devpts.

current->tty - it is a direct internal reference.

Alan
