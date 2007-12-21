Return-Path: <linux-kernel-owner+w=401wt.eu-S1760509AbXLUHto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509AbXLUHto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 02:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbXLUHth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 02:49:37 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:14254 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbXLUHtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 02:49:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Jj+eTQ7YmEbixaIVy/B+T/1KKiLMn5/GQQIcDZKWGCYBupgjYJk4VnXdAcaZzS+/fIeMHT3StqhIiuRsllaZzx0TcbPllQxqvylsM9U4lOTeZdObkiFUloBeHb/5UTmQq+3hspSAWA9o4hMZ7/ewIrBORJWe5922YUI3Hwejhe4=
Message-ID: <2e84de770712202349t5ab514a2w2c0f12b212e426dd@mail.gmail.com>
Date: Fri, 21 Dec 2007 00:49:36 -0700
From: "Michael Heath" <mike.thomas.heath@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Some Serial Wacom Tablet devices failing to return from Hibernate/Suspend
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lot of Ubuntu users have noticed troubles with Wacom Serial Tablet
devices (mainly builtin units in Toshiba tablet PCs) refusing to
properly return from ACPI Suspend or Hibernate. See the bug report at:
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/152187

Tom Jaeger there noted that this bug seems to reside in some ACPI
related IRQ handling code for such devices introduced in 2.6.21-rc4,
via a patch to fix Parallel Port IRQs on resumes. You can see his
whole bug report on the issue (including some tentative
shot-in-the-dark patches) at
http://bugzilla.kernel.org/show_bug.cgi?id=9487

This seems to be affecting a fair amount of users, and all of us
active on the bug in the Ubuntu tracker aren't familiar enough with
the ACPI subsystem to create a correct patch for this issue. Is anyone
familiar enough with this area that they can provide some guidance on
the correct way to fix this issue, beyond the quick fix Tom Jaeger
posted?

Michael Heath
