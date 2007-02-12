Return-Path: <linux-kernel-owner+w=401wt.eu-S965295AbXBLSpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965295AbXBLSpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965294AbXBLSpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:45:34 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:43342 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965292AbXBLSpd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:45:33 -0500
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: linux-acpi@vger.kernel.org
Subject: /proc/acpi/ac_adapter/AC is missing after latest ACPI merge
Date: Mon, 12 Feb 2007 20:45:33 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702122045.34951.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After latest ACPI merge /proc/acpi/ac_adapter/AC has gone fishing :

[~]> ls -al /proc/acpi/ac_adapter/
dr-xr-xr-x  2 root root 0 Şub 12 20:44 ADP1

[~]> ls -al /proc/acpi/ac_adapter/ADP1
-r--r--r-- 1 root root 0 Şub 12 20:44 state

This at least breaks HAL which thinks AC is always plugged in, is this change 
intentional?

Regards,
ismail
