Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbZFXRRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbZFXRRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 13:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbZFXRRC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 13:17:02 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:44822 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbZFXRRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 13:17:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=AK639CzS1FByZuLRfcoTXRsZ/bRg4fUl4MN0o1me5crfZFbs73Y6e7hEzGOoy/QWtx
         JEKeYCAnWtbjJ+/XReVt3m6p2AcH+mtGsVWZZmqt4LdfJHmY/8odEEDBwR+X4eb3lpKi
         LgPGcCsRnnqn8WB7uDlSdmoEQ1Qp/TMxZ4HWY=
Message-ID: <4A425F8B.2000907@gmail.com>
Date: Wed, 24 Jun 2009 19:16:59 +0200
From: Karl Beldan <karl.beldan@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: linux-ext4@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>, bdonlan@gmail.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2] ext[234]: Return -EIO not -ESTALE on directory traversal
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

e6f009b for ext4,
de18f3b for ext3.

It seems that ext2 didn't get it.

