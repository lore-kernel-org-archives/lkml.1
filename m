Return-Path: <linux-kernel-owner+w=401wt.eu-S1757656AbZJaCKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656AbZJaCKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 22:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757645AbZJaCKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 22:10:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:24706 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757643AbZJaCKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 22:10:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=O0bh9+lnz0VTkaIPBSK0N4aOZbxn3pj4vTDUa4DrJPP8x8pLXynWEtKav+JAnJwPb9
         Rr2XbY0TQgyKnYHdD3mMJbkc0+XCAgMuIB5rpcGCniWLMXCE6fdbnnuvLXdEYOoHSoc9
         7vs4w/vrDdfs6fkXSeXyIVQcO9vgtDdCEM2wk=
Subject: ALPS touchpad with 4 directions button doesnt work as intended
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Dmitry Torokhov <dtor@mail.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Oct 2009 04:10:18 +0200
Message-ID: <1256955018.9681.23.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a acer 5720G laptop, and its touchpad (ALPS) has three buttons,
usual left/right, and middle button that can be pressed in 4 directions.
Up/down direction work fine, but left/right doesn't. This means that
left direction  produces middle button click, and right direction
doesn't work at all.
I took a look at source, and I see that driver doesn't even know about
such configuration.

Now I am sure its very easy to figure out what is send when no working
button is pressed, but I am a bit confused what BTN_* event to assign to
it, so it will work as horizontal scroll as intended.
And unassign middle button from other direction....

Can you help me a bit?

I am ccing authors of alps.c

Best regards,
Maxim Levitsky



