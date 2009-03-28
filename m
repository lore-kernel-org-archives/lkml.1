Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbZC1I0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbZC1I0Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 04:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbZC1I0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 04:26:03 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:34970 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbZC1I0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 04:26:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Fv5Lvj7Ikji6DGhkcVLnCOguGsqhe9iVchRlA8yKc7X5VPotejgBAr/QEH1tmXttW+
         hBL8IhAOwU7TA5mKs0N3cLMqNfnR+lagyKRaX77jxmDtoagdHxoGGI1TOoGFtZo5zxXY
         o6DAfZ22MxXkh+EdlVkgAstkUD2UGeLLXDCd4=
MIME-Version: 1.0
Date: Sat, 28 Mar 2009 09:25:57 +0100
Message-ID: <2d05c4580903280125we93e60cod7ce8a53a7573788@mail.gmail.com>
Subject: error: attribute '__cold__': unknown attribute
From: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I compile latest kernel sources [2.6.29] I get on almost every
line message :

error: attribute '__cold__': unknown attribute

I looked on the internet about __cold__ and I found this:

-----------------------------------------------------------------------------------------------------------------------
"gcc 4.3 supports a new __attribute__((__cold__)) to mark functions cold. Any
path directly leading to a call of this function will be unlikely. And gcc
will try to generate smaller code for the function itself.

Please use with care. The code generation advantage isn't large and in most
cases it is not worth uglifying code with this.
"
-----------------------------------------------------------------------------------------------------------------------

Will see at home which version of gcc I have, maybe if I have less
than gcc 4.3 and get gcc 4.3 it will be solved.

But anyway, what is "mark functions cold", what is this functionality ?

thanks,

Dragoslav Zaric,
[Professional programmer, M.Sc Astrophysics]
