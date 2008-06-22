Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYFVJLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYFVJLx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 05:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbYFVJLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 05:11:43 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:59679 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbYFVJLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 05:11:42 -0400
Date: Sun, 22 Jun 2008 11:11:41 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: "Christian P. Schmidt" <schmidt@digadd.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Sending UDP packets to port 0
In-Reply-To: <485E0B1C.7030105@digadd.de>
Message-ID: <alpine.LNX.1.10.0806221110440.15126@fbirervta.pbzchgretzou.qr>
References: <485E0B1C.7030105@digadd.de>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2008-06-22 10:19, Christian P. Schmidt wrote:
>
> RFC 1350 (TFTP) even states explicitly:
> The transfer identifiers (TID's) used by TFTP are passed to the Datagram layer
> to be used as ports; therefore they must be between 0 and 65,535.

One could interpret "between" as  0 > x < 65535 and not
0 >= x <= 65535 (that could be "between (inclusive)").

