Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbZBZMGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbZBZMGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 07:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbZBZMGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 07:06:25 -0500
Received: from silene.metacarta.com ([208.80.142.18]:39327 "EHLO
	silene.metacarta.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbZBZMGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 07:06:24 -0500
Date: Thu, 26 Feb 2009 07:06:21 -0500 (EST)
From: Joe Malicki <jmalicki@metacarta.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Kenneth Baker <bakerkj@metacarta.com>, Michael Itz <mitz@metacarta.com>
Message-ID: <18521844.9754741235649981642.JavaMail.root@ouachita>
In-Reply-To: <9683328.9717571235603514325.JavaMail.root@ouachita>
Subject: Re: BUG: setuid sometimes doesn't.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [66.31.17.145]
X-Mailer: Zimbra 5.0.9_GA_2533.UBUNTU6 (ZimbraWebClient - FF3.0 (Mac)/5.0.9_GA_2533.UBUNTU6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Joe Malicki" <jmalicki@metacarta.com> wrote:

> Very rarely, we experience a setuid program not properly getting
> the euid of its owner.
> 
> Thus far, we have only seen failures for the program being setuid
> root, being run by a non-root user, on a multi-core machine.  Trying
> to
> setuid to a user from root, *or* booting with maxcpus=1 and trying to
> setuid from a non-root user to root, both fail.

Sorry, misstated that.

setuid from nonroot->root, or with maxcpus=1, always seems to work.

Only multiple cores with setuid to root has failed for us.

-Joe Malicki
