Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbZLBAc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbZLBAc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 19:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbZLBAc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 19:32:58 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:47779 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbZLBAc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 19:32:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=pQCMyVrnWdVBDqUeOrW27E3FyGchT0whvkBJ3GfeeR+GrsDBSsNmjlyuID1IK9A3ft
         e7dsKG/E8mYsBRxzWqGN/g+TNZtHY5dxsEfkCx3o0owcpBWBDH0ICL/JcEEx3e0Mwq1A
         GE28YUO0T7a+Idp89uM6nP6N4aPzlamclyEHg=
MIME-Version: 1.0
Date: Tue, 1 Dec 2009 16:27:41 -0800
Message-ID: <911b679e0912011627q568132e8x655f109c75030725@mail.gmail.com>
Subject: Key change for TCP_MD5
From: Xiaochun Lu <xiaoclu@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, ALL

This is regarding to TCP-MD5 option [RFC2385].  In current
implementation, only one md5 password is saved in the kernel and it
brings in the problem for changing key:  Changing key in the middle of
tcp session will break the session unless new md5 password is updated
at both ends at the same time (there is no window for key change).
Does anybody know any patches currently exist to address this issue? I
know rfc4808 is targeting to solve this issue. Does there any plan to
implement rfc4808 for linux?

Best Regards!


Shawn Lu
