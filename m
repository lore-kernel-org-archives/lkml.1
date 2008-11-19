Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbYKSNQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbYKSNQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 08:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbYKSNQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 08:16:21 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:52375 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbYKSNQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 08:16:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:bcc:subject:date:user-agent:message-id;
        b=g+r3sG42+93sSVQQ+tGyfqKJrLfulpM2yU0t96hvchzku4dhM6PzJkSpqNLQFKtY8C
         J3KhsDVJJRok4UZA4j8qU25fy5vvrccZ8dIh/eeqqwZfVM1SWVWD9lF0wvWwkO1tVxEw
         WtOkVRLYkqV06HE6upTQyOA0k0RQXR2z40E9Y=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Mike Rapoport <mike@compulab.co.il>,
       Mike Lavender <mike@steroidmicros.com>,
       David Hinds <dahinds@users.sourceforge.net>
Subject: [PATCH 0/4] MTD: mark {__init|__exit} for {init|exit} functions
Date: Wed, 19 Nov 2008 21:16:09 +0800
User-Agent: sniper-patch-carrier/1.06
Message-ID: <492411a1.04506e0a.02d2.0c20@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these (init|exit) functions is called from
other functions which is outside the kernel module
mechanism or kernel itself, so mark them as
{__init|__exit}.

