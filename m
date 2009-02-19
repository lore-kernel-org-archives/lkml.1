Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbZBSUbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbZBSUbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 15:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbZBSUbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 15:31:33 -0500
Received: from web34402.mail.mud.yahoo.com ([66.163.178.151]:29136 "HELO
	web34402.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751680AbZBSUbc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:31:32 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Feb 2009 15:31:32 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.br;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=2pAeG4L0DMm/6IN1H5IiTTM3MRg458fBzhBV8pNdnNoYobuEQu1RZrIzQqL3+4kVxQowRzbAocqbZEGVoYDlF+sYuIBKp2nofP9bIdKlk9RRL+Z3WtMtDIe0b7sQlXL/b9eUAYfBbLiOCqNTJtmWS9/G7eccAB6Vv/WD719TZBA=;
X-YMail-OSG: _NnWs0cVM1mCixII6bvz64reMIEsuRHKxEzXhZ9csmAqvljXSJSjPSYKMx0YbQ3oMAAJyobBSVEc82OSEBwn8K5c8BAnCo8drmCT08ga.Zw1HaNL15InSw4I3AYSJchAfyx9McbFDHbZgfr01jPtiIcKNKnOEf571o4gBAnu8DlmSYEJcdsQixtIQ7nvirVnCPhhzynczeiDsa1IXVOpXt5dKQODtA--
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 19 Feb 2009 12:24:51 -0800 (PST)
From: Jose Luis Marchetti <joseluismarchetti@yahoo.com.br>
Reply-To: joseluismarchetti@yahoo.com.br
Subject: Is interrupt priority supported ?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <657201.46675.qm@web34402.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am experiencing serial (115K) data loss when I have concurrent heavy Ethernet traffic. I have added some basic trace into the UART driver and could confirm the Ethernet data interrupt, if with enough data and happening in the right place would cause the UART FIFO to fill.
BTW this is happening on a embedded processor, not on the usual ( and fast ) PC.
Then I tried to set the serial interrupt priority to be higher than the Ethernet interrupt priority, just because the UART I am using have just 4 bytes of FIFO while the Ethernet have thousands...

But I am not able to find where this is done in Linux, is interrupt priority supported at all ?

Thanks in advance for any comments,

José Luís Marchetti


      Veja quais são os assuntos do momento no Yahoo! +Buscados
http://br.maisbuscados.yahoo.com
