Return-Path: <linux-kernel-owner+w=401wt.eu-S1758647AbZABRhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbZABRhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 12:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757432AbZABRhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 12:37:03 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:46849 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281AbZABRhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 12:37:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=OOUiFMj/69F3OUxaxlFcRaXr4QSfb2RzvNfQEX1gNIu/C6wc2sbu8xhqknfqrtAOUK
         EDCqcROBn47w4PlyezvLYaMM91zsPU220oCxhoqvWOYI3cFpHAnlYcgM2iVVUfjN4iJq
         w65BJ1h2MnpFVK/ue93TI0B07ggZ5pEqIodsM=
Message-ID: <3f9a31f40901020936l4bed87e2jb64678572d2ad45b@mail.gmail.com>
Date: Fri, 2 Jan 2009 23:06:58 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "x86 maintainers" <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, ath9k-devel@venema.h4ckr.net
Subject: tip - Solution of ath9k: turn off temporarily (66b5c4a2c638b5a69d3e41abe4a2bae55035a92e)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

If you choose :
CONFIG_RFKILL=m
CONFIG_ATH9K=y

It will give linking error because ATH9K need RFKILL functions.

But if you choose :
 CONFIG_RFKILL=y
 CONFIG_ATH9K=y

OR

 CONFIG_RFKILL=m
 CONFIG_ATH9K=m

It is OK.

Thanks,
JSR
