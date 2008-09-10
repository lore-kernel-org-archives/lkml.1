Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbYIJWLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbYIJWLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYIJWLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:11:43 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:38827 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbYIJWLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:11:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=j7yWx/A2vDFkvhSMhUqQ/XRsY+qWlHKu2Myrl4LMXHEPmOeNOATqsDwGDIRt8qcQ3G
         O6HVSZVe/JPB1QILJiYO+2dyyzbBvesQjPaOgoyFa7lcc7Ihk0QEeCPfFonOrJr99R//
         X0MSNACT7CSGhlNEGNe2+L08CE0FOAwoCp4zU=
Message-ID: <48C84619.8030303@gmail.com>
Date: Thu, 11 Sep 2008 00:11:37 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Marcin Obara <marcin_obara@users.sourceforge.net>,
       Marcel Selhorst <tpm@selhorst.net>, Kylene Jo Hall <kjhall@us.ibm.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       srajiv@linux.vnet.ibm.com, debora@linux.vnet.ibm.com
Subject: tpm-correct-tpm-timeouts-to-jiffies-conversion.patch -> 2.6.27
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is it possible to push
tpm-correct-tpm-timeouts-to-jiffies-conversion.patch
(the patch header follows) into 2.6.27, please?

From: Marcin Obara <marcin_obara@users.sourceforge.net>

This patch fixes timeouts conversion to jiffies, by replacing
msecs_to_jiffies() calls with usecs_to_jiffies().  According to TCG TPM
Specification Version 1.2 Revision 103 (pages 166, 167) TPM timeouts and
durations are returned in microseconds (usec) not in miliseconds (msec).

Signed-off-by: Marcin Obara <marcin_obara@users.sourceforge.net>
Cc: Marcel Selhorst <tpm@selhorst.net>
Cc: Kylene Jo Hall <kjhall@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

