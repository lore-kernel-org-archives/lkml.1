Return-Path: <linux-kernel-owner+w=401wt.eu-S2993005AbXEBKa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993005AbXEBKa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 06:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993008AbXEBKa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 06:30:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52824
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2993005AbXEBKa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 06:30:27 -0400
Date: Wed, 02 May 2007 03:30:25 -0700 (PDT)
Message-Id: <20070502.033025.15241258.davem@davemloft.net>
To: d13f00l@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Strange UDP Issue on 2.6.20.8 - broadcasts not being received
 if socket bound to local ip
From: David Miller <davem@davemloft.net>
In-Reply-To: <47ed01bd0705020255x3a05cabbo955b4e980771b92@mail.gmail.com>
References: <47ed01bd0705020255x3a05cabbo955b4e980771b92@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


SO_BROADCAST controls sending, not receiving.

This definition comes from the BSD sockets API, even
Stevens TCP/IP Illustrated Volume 2, page 437, figure
15.4 clearly states that SO_BROADCAST means "socket
can send broadcast messages".  It says nothing about
receiving and the BSD implementation matches that
description, as does Linux.

This has been brought up before, search for the
subject "UDP Broadcasts not delivered to IP address"
in the linux-net list archives for one such thread.
