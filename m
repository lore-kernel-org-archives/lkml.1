Return-Path: <linux-kernel-owner+w=401wt.eu-S933847AbXDASgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847AbXDASgO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933832AbXDASgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:36:14 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:48734 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933847AbXDASgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:36:13 -0400
Date: Sun, 01 Apr 2007 20:36:11 +0200
Message-Id: <1714123823@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Ken Chen <kenchen@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] remove artificial software max_loop limit
Organization: http://freemail.web.de/
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Blame on the dual meaning of max_loop that it uses currently: to
>initialize a set of loop devices and as a side effect, it also sets
>the upper limit.  People are complaining about the former constrain,
>isn't it?  Does anyone uses the 2nd meaning of upper limit?
>
>- Ken

what sense would it make to set an upper limit at all?

we`re so happy to have none anymore :)

i think andrew`s suggestion is just good:

>So if we're worried about not breaking existing setups, we should retain
>this module parameter as a do-nothing thing, maybe with a
>this-is-going-away warning printk, too.


roland



_______________________________________________________________
SMS schreiben mit WEB.DE FreeMail - einfach, schnell und
kostenguenstig. Jetzt gleich testen! http://f.web.de/?mc=021192

