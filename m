Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbZFEQnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbZFEQnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 12:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZFEQnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 12:43:07 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:48037 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZFEQnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 12:43:06 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: linux-kernel@vger.kernel.org
Subject: [Compile Warning] 2.6.30-rc8 build
Date: Fri, 5 Jun 2009 11:43:03 -0500
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906051143.06119.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group,

To my reading of the function, I think gcc has a point:

drivers/serial/8250.c: In function 'serial8250_shutdown':
drivers/serial/8250.c:1685: warning: 'i' may be used uninitialized in this function

It does read as if the code might try to initialize
the 'lock' field of a null pointer.

Suggestions?

Mike
