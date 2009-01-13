Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbZAMSnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbZAMSnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbZAMSn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:43:29 -0500
Received: from web56803.mail.re3.yahoo.com ([66.196.97.77]:36914 "HELO
	web56803.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753702AbZAMSn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:43:28 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2009 13:43:28 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=xQrWxLUgUppCLHcripIoQCkMs9kyAb+w28OwGIS6gfoTPb11WWKwGQoUvvVmZOgTtO589ONtSwSFo50uAe+JznQ8CsJqpBIX4zHr6jrINaUHZEYHsQxNp1AIo51AQBsvJeBWPxvnD6iEvaOoY9X+bYODhcsTiSRDFYv3OMvuQ2A=;
X-YMail-OSG: S7vxHWUVM1nrYF3.i7rJ.q4.N7dVQQQ.fBwwD.OYTp5BPc01ja5jQUAA2s2DxQLZV76jIZr3MxsAAMJypBqyjbzoFDDXdEDQZ8KetANaYLd7_y3Al337U607.Io_Zh8PpV9d1g8LT2YA.wAh2RreJig8MtwV7TqNq3vgQObugpvwutKqV3pKsa6zrpTUIMSGQ9JR0Gm6UTf9mfUoUmf.q.CTlMxu
X-Mailer: YahooMailRC/1155.45 YahooMailWebService/0.7.260.1
Date: Tue, 13 Jan 2009 10:36:47 -0800 (PST)
From: Daniel Gagnon <daniel.gagnon@yahoo.com>
Subject: [PATCH] serial: Add SupraExpress 336i PnP Voice Modem
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <181809.8199.qm@web56803.mail.re3.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add SupraExpress 336i PnP Voice Modem

Tested and working with the following device: (output from lspnp -v)
01:01.00 SUP1381 (unknown)
    state = active
        io 0x2f8-0x2ff
        irq 3

Signed-off-by: Daniel Gagnon <daniel.gagnon <at> yahoo.com>

diff --git a/drivers/serial/8250_pnp.c b/drivers/serial/8250_pnp.c
index fde7f9c..7bc77ea 100644
--- a/drivers/serial/8250_pnp.c
+++ b/drivers/serial/8250_pnp.c
@@ -270,6 +270,8 @@ static const struct pnp_device_id pnp_dev_table[] = {
        {       "RSS0250",              0       },
        /* SupraExpress 28.8 Data/Fax PnP modem */
        {       "SUP1310",              0       },
+       /* SupraExpress 336i PnP Voice Modem */
+       {       "SUP1381",              0       },
        /* SupraExpress 33.6 Data/Fax PnP modem */
        {       "SUP1421",              0       },
        /* SupraExpress 33.6 Data/Fax PnP modem */


      __________________________________________________________________
Be smarter than spam. See how smart SpamGuard is at giving junk email the boot with the All-new Yahoo! Mail.  Click on Options in Mail and switch to New Mail today or register for free at http://mail.yahoo.ca
