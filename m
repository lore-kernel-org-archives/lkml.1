Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbYABNWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbYABNWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 08:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbYABNWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 08:22:12 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:37130 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbYABNWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 08:22:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=oSMNy0DklBaj7tEgzcJkPEHGIfxmZVR3WUy6PDMlSLTRRW3J54eFM6yRjrOYc+W/wsPPMtET5+1Book+N4hW9AMVabG3rqOTV3aE5KMscLPxPNttmYR89NKqWdyvclU570fEMdfXWkEsPng+hSwbQVblA0TgHoRHdyy6LKJquGw=
Message-ID: <60d29d630801020522r737ea96cl7693567298d28aca@mail.gmail.com>
Date: Wed, 2 Jan 2008 14:22:08 +0100
From: Abdel <draconux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: macro _set_base - "do - while(0)" question
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/2, DervishD <lkml@dervishd.net>:

>    * Abdel <draconux@gmail.com> dixit:
>    > In file include/asm-i386/system.h,  _set_base and _set_limit use an
>    > useless do ... while(0)
>    >
>    > Why is this needed ?
>
>    Google for "do while swallow semicolon". This looks like an useless and
>    weird construction but it is very useful when it comes to macros (you
>    can define variables inside the block and you can use your macro as any
>    other statement, it won't swallow the semicolon).


thanks to all for your responses :)

-- 
Abdel
http://draconux.free.fr/
