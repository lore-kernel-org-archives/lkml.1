Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbYJQNQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbYJQNQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 09:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbYJQNQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 09:16:27 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:27928 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbYJQNQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 09:16:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tKJ9Jx7I0W/hi9LZ4AuBsRC+7MwYB4Sub8eJ05hRYt/JZaHbTwWycEkibPVU5Vp/Q6
         KFPD0LQnTBMLdYZndYPpG4O0gtGbV08HvlhXLepunwV1lZ8nY0nRwNpadRFm6affgfbz
         UO5Yjp7ZYYt199H6PewD9K2liWsakuwDR/ce4=
From: Jike Song <albcamus@gmail.com>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: add missed clobber for 32-bit memmove
Date: Fri, 17 Oct 2008 21:15:52 +0800
Message-Id: <1224249353-3032-1-git-send-email-albcamus@gmail.com>
X-Mailer: git-send-email 1.6.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


