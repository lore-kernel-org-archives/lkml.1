Return-Path: <linux-kernel-owner+w=401wt.eu-S1762838AbXH3Qsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762838AbXH3Qsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 12:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760466AbXH3QsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 12:48:24 -0400
Received: from web52002.mail.re2.yahoo.com ([206.190.49.249]:24068 "HELO
	web52002.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760354AbXH3QsX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 12:48:23 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Aug 2007 12:48:23 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=fonC8m2D6elyKZruWCCWdmYh57TsBuDbgQduOTi2E6+7cGTjFR7LAvD1l2dGVuQ70+F8e9Edh8fR0ENJwxuCQj0byBVX4QCzVYtGZXxM4oFPUd5Xy8gAjNYu5edGOwW7ncpznUdyh6G4+tZgy7/dmu1GS/HBmfrLiveEzAP94TQ=;
X-YMail-OSG: WjH_9C8VM1l6hTIQtQB4cEr6CWOabSLbxrSM_YEQFoIqZP4Ekj3M54VhLrS9JkmAYvXke3Y4kUYg2waJ4pn1vbH3MsVz3PCA.eh_Le.mSWFIcACe8U8.E8e._dUhTA--
X-Mailer: YahooMailRC/651.48 YahooMailWebService/0.7.134
Date: Thu, 30 Aug 2007 09:41:41 -0700 (PDT)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: [Bugme-new] [Bug 8957] New: Exported functions and variables
To: linux-kernel@vger.kernel.org
Cc: bugme-daemon@kernel-bugs.osdl.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <910709.35108.qm@web52002.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I thought that the bug might happen when two kernel modules are being loaded. If module A is loaded and its code includes references to functions exported by module B, I thought module A could call those functions before the module_init function of module B has finished. I was not thinking about buggy calls to registering interface functions. I just thought that the kernel should not allow symbols exported by   EXPORT_SYMBOLto be visible to other modules before the module_init function is finished. One could code the exported functions so that they could be safely called by anyone while the module_init function is being called but that would be an unnecessary burden for coders. I think that a module should expose its functions and variables only by calling registering interface  functions before the module_init function is finished. So I think the design of the kernel modules is flawed if it allows anyone to call exported functions before the module_init
 function is finished.




      Heute schon einen Blick in die Zukunft von E-Mails wagen? Versuchen Sie´s mit dem neuen Yahoo! Mail. www.yahoo.de/mail
