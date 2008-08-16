Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbYHPTdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbYHPTdo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 15:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbYHPTdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 15:33:37 -0400
Received: from web37602.mail.mud.yahoo.com ([209.191.87.85]:25330 "HELO
	web37602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751014AbYHPTdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 15:33:36 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Aug 2008 15:33:36 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=Ss4qVIVchSw9zc5dljcWUvLGqXp6COdgcnY9mKSv/h/wJ0tZz1mNO246cLwJ+DvW2zFQIZp4iYs3ALDxrsEYHDWT1j7GDxEApbOoVAaAFVl4Fx4N1t8YpDWayjzqRaf9Df5Stf4KztorTQSbo8SyzW0xgLgcGSaEtuEBRUAR2wY=;
X-Mailer: YahooMailWebService/0.7.218
Date: Sat, 16 Aug 2008 12:26:54 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Reply-To: oakad@yahoo.com
Subject: Problem with find_first_bit function and kin
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <865989.50481.qm@web37602.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's well may be that I'm just missing something obvious.

It seems to me that find_first_bit/find_next_bit functions return their
offsets "base 1" - first set bit is "1" and last is "bitmap size". This
means that if only the last bit in the bitmap is set, the returned value
will be indistinguishable from no bits set situation. Moreover, bit
manipulation functions appear to use "base 0" bit addresses, adding to the
inconvenience.

Is this a desired behavior? And, if yes, how is one supposed to deal with last bit of the bitmap?



      
