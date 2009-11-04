Return-Path: <linux-kernel-owner+w=401wt.eu-S933014AbZKDVzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbZKDVzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932997AbZKDVzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:55:33 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35457 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932681AbZKDVzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:55:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OtsaUGqUL0/A/93IFxhBLfwBzINodnACFw0RpM3VyYtw9+D21Xerb/LlN0IFSAhScs
         1Bu/ZAOITprANHnUBOwNVXYKFuCktXnlZ/9y0YeC3fVHH9NNa2BNwC65a7Ddqp79QstM
         wQU1yhavfHONjFzcCVXub8ldFKyIHv1pbpgLs=
From: Paul Fertser <fercerpav@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Subject: [PATCH 0/3] rtc: pcf50633 fixes (is rtc maintainer around?)
Date: Thu,  5 Nov 2009 00:55:14 +0300
Message-Id: <1257371717-547-1-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series contains (~obvious) fixes for the rtc part of pcf50633
MFD.

Unfortunately, my previous posting seemingly didn't reach the target, i
received no reply from Alessandro Zummo and also rtc-linux@googlegroups.com
ML seems to be dead or at least unsuitable (lots of spam, weird way of
viewing archives). I omitted LKML the previous time because i thought that
since these fixes are so small and not interesting there's no sense in
bothering anybody with them.

[PATCH 1/3] rtc: pcf50633: Fix month off-by-one error
[PATCH 2/3] rtc: pcf50633: consider alrm->enable in pcf50633_rtc_set_alarm
[PATCH 3/3] rtc: pcf50633: manage RTC alarm "pending" flag

TIA
