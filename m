Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbZFSDOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbZFSDOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 23:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbZFSDN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 23:13:57 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:34191 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbZFSDN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 23:13:56 -0400
From: Xiaolei Cai <Xiaolei.Cai@synopsys.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 18 Jun 2009 20:13:56 -0700
Subject: process exit modify semaphore values.
Thread-Topic: process exit modify semaphore values.
Thread-Index: Acnwi/tsuKYa/+jxRBWAXD/LmIqjhA==
Message-ID: <27C98DBD82F21D40B17F071002A4EB3D1439D2CB@US01WXMBX1.internal.synopsys.com>
Accept-Language: en-US
Content-Language: en-US
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an application that uses unnamed POSIX semaphores as synchronization mechanism among parent and several child processes. It seems upon one child process exits, the semaphore values are all set to 0. This change of value brings deadlock to the still running processes. I observed this behavior with Linux 2.6.23-1 x86_64 or newer. We don't have this problem with Linux 2.6.9-67.ELsmp x86_64.

Is there a way to disable this annoying behavior in the newer version of linux kernel?

Thanks!
Xiaolei

