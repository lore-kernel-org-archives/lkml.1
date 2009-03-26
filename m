Return-Path: <linux-kernel-owner+w=401wt.eu-S1758339AbZCZNzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339AbZCZNzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 09:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756209AbZCZNzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 09:55:43 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:53286 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755209AbZCZNzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 09:55:42 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-06.arcor-online.net AEBF739A775
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: My new fancy font for framebuffer
To: "H. Peter Anvin" <hpa@zytor.com>,
       Felipe Contreras <felipe.contreras@gmail.com>,
       Baybal Ni <nikulinpi@gmail.com>, Ken Moffat <zarniwhoop@ntlworld.com>,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Thu, 26 Mar 2009 14:55:30 +0100
References: <cicyE-3qo-15@gated-at.bofh.it> <cidXL-5OQ-35@gated-at.bofh.it> <cinu8-41e-3@gated-at.bofh.it> <cisas-37w-5@gated-at.bofh.it> <ciFKp-7QW-17@gated-at.bofh.it> <cj8CE-3uO-11@gated-at.bofh.it> <cjo4C-3hh-13@gated-at.bofh.it> <cjoo1-3FO-13@gated-at.bofh.it> <cjoxL-3SW-35@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1Lmq3O-0001mo-Pf@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin <hpa@zytor.com> wrote:
> Felipe Contreras wrote:
>> 
>> I thought you had to distribute the source code only if you made
>> modifications. What's the point of distributing it _again_?
>> 
> 
> a) the license requires it.

No, you just have to offer the source.

OTOH, if the bdf2c-translator is reasonably small, put it into the utility
directory, define a user-stuff-directory, and write a "make fonts" section
which will insert $CONFIG_USER_STUFF/fonts/* into the kconfig menu.
(Or pre-define $CONFIG_USER_STUFF to a fixed directory in the kernel tree.)

just my ¢¢

