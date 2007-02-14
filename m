Return-Path: <linux-kernel-owner+w=401wt.eu-S932230AbXBNMu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbXBNMu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 07:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932233AbXBNMu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 07:50:58 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:61648 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230AbXBNMu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 07:50:58 -0500
Message-ID: <45D305B0.3070303@student.ltu.se>
Date: Wed, 14 Feb 2007 13:50:56 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC] drivers/scsi/advansys.c: Unused variable?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

This may be a petite question but does anyone know what the variable 
"false_overrun" (in drivers/scsi/advansys.c) is meant for?
While converting the file to generic booleans I saw it is defined 
without value, can get the value of 'false' and then is used in an 
if-statement. So even if it is defined as 0 by default the if-statement 
is always false.

Richard Knutsson

