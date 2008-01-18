Return-Path: <linux-kernel-owner+w=401wt.eu-S1759616AbYARAf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616AbYARAf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757086AbYARAfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:35:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759350AbYARAfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:35:43 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org
Subject: [PATCH 0/7] More lguest massage.
Date: Thu, 17 Jan 2008 22:35:43 -0200
Message-Id: <1200616550283-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series takes one more step towards cpu-ification of lguest.
As for rusty's last suggestion, I get rid of the whole bunch
of "struct lguest *lg = cpu->lg" statements around by using
lg_cpu as our base structure wherever it matters. (this saves us
11 lines)


