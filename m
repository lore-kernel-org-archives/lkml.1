Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbZJVLKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbZJVLKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 07:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbZJVLKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 07:10:45 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:45028 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbZJVLKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 07:10:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=VlDqClnD1Mf5UM45MBqVRpPuNo3ecbPcaQIs52YfvloOBR3e8rlFKBUCvb6rlgY62z
         VXB9re1MqPfju1RseFeLtE8v1tbTPaJFnO8iBBK4/N9dbKQTZEQatjL+UW1XyDne5Rqg
         EBrZS/zNlKLL8WCyqoYkzdXoD22gSbk7Fib0w=
MIME-Version: 1.0
Date: Thu, 22 Oct 2009 04:10:49 -0700
Message-ID: <f22d86810910220410r33002b5ei403ddf6632254472@mail.gmail.com>
Subject: Can current macro be accessed from interrupt context?
From: "Leonidas ." <leonidas137@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Going through UTLK, it says that current macro makes sense only in
case of process context,
in case of interrupt context it is invalid.

But current would still be pointing to interrupted process right? The
pointer would still be valid?
Can I safely assume that whether or not interrupt handlers are
executing on separate stacks or
interrupted threads stack, current macro can be accessed from interrupt context?

My use case is to get process id from any context with CONFIG_4KSTACKS = 0 or 1.

Any pointers will be helpful.
-Leo.
