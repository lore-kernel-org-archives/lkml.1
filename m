Return-Path: <linux-kernel-owner+w=401wt.eu-S932285AbXHCX77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285AbXHCX77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 19:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761301AbXHCX7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 19:59:53 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:3228 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760973AbXHCX7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 19:59:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Aqs1qbZit6lj894KUdzyxu3hHGTAYsn0+v6io4rpguab1HlmbAidZNHjG9wQ71KBXs95SwdPv806P6Os9yOBOEgMORgkLTDW0ODEB717JqpFu/IYltZjVCtOS1IfuY2878HnsFoD8xZzYV2zVUA6v/8hZ2uokNFYm24BFYkIsJs=
Message-ID: <8bd0f97a0708031659o1e32722cq99b1c248367d6da6@mail.gmail.com>
Date: Fri, 3 Aug 2007 19:59:51 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: custom baud rates with serial core
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

is there a method for setting custom baud rates that doesnt cause a
"deprecated" message from showing up ?  for example:
# setserial -a /dev/ttyBF0 divisor 9 spd_cust
setserial sets custom speed on ttyBF0. This is deprecated.

my reading of the serial core code is that the only way to specify a
baud rate that does not appear in the B* define list is by setting
your baud to B38400 and utilizing UPF_SPD_CUST.  this ends up in the
deprecated warning code though in uart_set_info().

if it's deprecated in favor of something nicer, that's fine, but i
cant find out what that "nicer" thing is ...
-mike
