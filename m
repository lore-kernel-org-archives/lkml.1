Return-Path: <linux-kernel-owner+w=401wt.eu-S965352AbXDLATG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965352AbXDLATG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 20:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965396AbXDLATG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 20:19:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965352AbXDLATE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 20:19:04 -0400
Date: Wed, 11 Apr 2007 17:17:49 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: petero2@telia.com
Cc: <dtor@insightbb.com>, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: One odd thing about Synaptics
Message-Id: <20070411171749.2337d620.zaitcev@redhat.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter:

There's one thing I wanted to report, just in case... It does not affect
anything, but it's odd.

Every time I lift a finger from the pad, the driver sends an event with
odd values (X is 1 and Y is 5855):

Event: time 1174695694.561806, type 1 (Key), code 330 (Touch), value 0
Event: time 1174695694.561809, type 3 (Absolute), code 0 (X), value 1425
Event: time 1174695694.561811, type 3 (Absolute), code 1 (Y), value 1223
Event: time 1174695694.561813, type 3 (Absolute), code 24 (Pressure), value 20
Event: time 1174695694.561816, -------------- Report Sync ------------
Event: time 1174695694.573918, type 3 (Absolute), code 0 (X), value 1500
Event: time 1174695694.573921, type 3 (Absolute), code 1 (Y), value 1265
Event: time 1174695694.573922, type 3 (Absolute), code 24 (Pressure), value 5
Event: time 1174695694.573924, type 3 (Absolute), code 28 (Tool Width), value 5
Event: time 1174695694.573926, -------------- Report Sync ------------
Event: time 1174695694.585575, type 3 (Absolute), code 0 (X), value 1
Event: time 1174695694.585578, type 3 (Absolute), code 1 (Y), value 5855
Event: time 1174695694.585580, type 3 (Absolute), code 24 (Pressure), value 2
Event: time 1174695694.585582, type 1 (Key), code 325 (ToolFinger), value 0
Event: time 1174695694.585584, type 1 (Key), code 333 (Tool Doubletap), value 1
Event: time 1174695694.585587, -------------- Report Sync ------------
Event: time 1174695694.622685, type 3 (Absolute), code 24 (Pressure), value 1

This correspods to hw.x=1, hw.y=0 in the driver. Looks like a bug somewhere.

Cheers,
-- Pete
