Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbXIQA6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbXIQA6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 20:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbXIQA6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 20:58:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:4837 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbXIQA6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 20:58:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=ZVUEXlf6wFbGLWjLnxGCD9xn+vF7z9GIHwTIqNxfFWaWCRI9A8sz4r+6JIz6DC7BYHVYWvTuwDwpCgkiNVotvNiLvf/tsXb2e2NAE9r1zbiqJDAkQDv0J3OdrsiM7GivQpH8odwIJUe1PqSWqpxhQok/UFyHS015HHjMBl1sIAo=
Message-ID: <46EDD114.7010403@gmail.com>
Date: Mon, 17 Sep 2007 09:57:56 +0900
From: shinkoi2005a <shinkoi2005a@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070615 Fedora/2.0.0.4-1.fc7 Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: printk format "%4.4s"
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

I have a question about printk format.

Can printk format use "%4.4s"?
This format is used following source.

#############
drivers/acpi/tables/tbinstal.c
                ACPI_ERROR((AE_INFO,
                            "Table has invalid signature [%4.4s], must be SSDT, PSDT or OEMx",
                            table_desc->pointer->signature));

##############
At least, my dmesg is buggy output like that..

##############
$ dmesg
(snip)
ACPI Warning (tbutils-0158): Incorrect checksum in table [  ^E礑 -  00, should b
e F6 [20070126]
ACPI Error (tbinstal-0134): Table has invalid signature [  ^E礑, must be SSDT, P
SDT or OEMx [20070126]
(snip)
##############

