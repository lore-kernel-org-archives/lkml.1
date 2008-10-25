Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbYJYSva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbYJYSva (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 14:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbYJYSvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 14:51:20 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:29028 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbYJYSvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 14:51:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TFbXdfr1UgJQGFf7dBgbExKbhHMkh6mH/Xi3oG9m1kZGN3TJBm22rVHbc9zqBO9pg0
         i8b0aICIw92Iw8eHdD2o8rWpEXCLLQU1TZ2CNCTazfO56JAGUDcRMJeoTteek+KH96O1
         4dnFQDHeFIciMabanSenGlVxvAecMJz1HyO9c=
Message-ID: <8db1092f0810251151l4c7f9382r34defa6d4d6ee24c@mail.gmail.com>
Date: Sat, 25 Oct 2008 20:51:17 +0200
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Re: Linux 2.6.28-rc1] ACPI Warning (nspredef-0852)[...]
Cc: "Robert Hancock" <hancockr@shaw.ca>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, lenb@kernel.org, fabio.comolli@gmail.com
In-Reply-To: <200810252004.01274.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.1HaqObZirROiyqr922A7hRDVc54@ifi.uio.no>
	 <fa.Rzh43vSl9NX1QQ2nOYQSgEJcZAw@ifi.uio.no> <49035313.9080309@shaw.ca>
	 <200810252004.01274.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suspend to ram, but another machine (previous PC, now laptop) and
another problem:

ACPI: EC: missing confirmations, switch off interrupt mode.
ACPI Exception (evregion-0419): AE_TIME, Returned by Handler for
[EmbeddedControl] [20080926]
ACPI Error (psparse-0524): Method parse/execution failed [\_TZ_.C31E]
(Node f7019858), AE_TIME
ACPI Error (psparse-0524): Method parse/execution failed
[\_TZ_.TZ3_._TMP] (Node f7019ed0), AE_TIME

It doesn't happened immediately after s2ram but is correlation between
s2ram and this error.

Thermal zone seems OK (fan works)

Dmesg, acpidump:
http://unixy.pl/maciek/download/kernel/2.6.28-rc1_tz/

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
