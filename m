Return-Path: <linux-kernel-owner+w=401wt.eu-S1762705AbZLKWUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762705AbZLKWUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761549AbZLKWU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:20:28 -0500
Received: from web50202.mail.re2.yahoo.com ([206.190.38.43]:47667 "HELO
	web50202.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762700AbZLKWUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:20:25 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Dec 2009 17:20:25 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=f4wTeuGGsEJrEwBr2f1dxEDduYZ74iXYM4fPlgOz6dFJgtcAoLuD/Av00MOD++ymAD3AAkO5b4QqJfiqSGFY2mogbs38kN464X2dOfZURrHZSzzSpcOVFK8Hxg2WE5XqzsmiRmo4AEjJAPlw92u4uXs96Qw1njCF5kxtel03Pvs=;
Message-ID: <549371.88681.qm@web50202.mail.re2.yahoo.com>
X-YMail-OSG: dproUaMVM1m7mYEWhuJBYF8qJnXVM70U7DoiiKMcgzKsogbpUSbwZ2UNN6RQ3UlfntW69rAZKekdRN0a6hjo69.qnSQFHLOtGnVaKAFf6q5rx6S.yd4Vs.M_k.eOOj5oa1FDxEGpKjktEC4fjTCeirbmXe5SZTU_8nahXULPuE61PgYJdiw0ahuKDOeQaD3sSLlMQoI2O26s6E92PMHixZ8hTk9NvcPIKkxfS1Zu2psxnN_r2zaD7mqTRugyytegfBZ6nKmyjDdMlr5Q_G7Cb6CiIbCRhlegBBubCgk-
X-Mailer: YahooMailClassic/9.0.19 YahooMailWebService/0.8.100.260964
Date: Fri, 11 Dec 2009 14:13:51 -0800 (PST)
From: raychan <raychan2001@yahoo.com>
Subject: implementing a custom uart driver
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

    I have been writing a custom uart driver for a SoC. It's not the 8520/16550 flavor so I ended up implementing a struct uart_driver on my own. However I am having some issues on the TX side.

    If I put a printk statement after I enabled TX interrupts then it starts outputting characters. Otherwise the console will just get stuck. It is a memory mapped IO device, it does not support any modem control signals so I simply return TIOM_CTS | TIOCM_DSR | TIOCM_CD in the driver's get_mctrl function. Are there any other caveats that I should be aware of?

Thanks much
Ray


      
