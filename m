Return-Path: <linux-kernel-owner+w=401wt.eu-S934120AbXG0Ecu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934120AbXG0Ecu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 00:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbXG0Ecl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 00:32:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60701 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbXG0Eck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 00:32:40 -0400
Message-ID: <46A97565.6070409@zytor.com>
Date: Thu, 26 Jul 2007 21:32:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jian-Xin Lai <laijx03@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: wrong constraints "=g" at include/asm-i386/string.h, line 186?
References: <824323160707260458h490e9ae5la44aabcfa413bba7@mail.gmail.com>	 <46A8BBF2.5010406@zytor.com> <824323160707261945n2e625beal486c7b1cfe91e01c@mail.gmail.com>
In-Reply-To: <824323160707261945n2e625beal486c7b1cfe91e01c@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jian-Xin Lai wrote:
> But as we know, the kerword 'register' is only a suggestion. The
> language specification does not force to put the 'register' variable
> into a register.
> Putting the variable onto stack does not violate anything, but the
> assembler will fail.
> I think the hack does not really work. THX.

Well, gcc is a bit more strict than that, but it's ugly and should be fixed.

	-hpa
