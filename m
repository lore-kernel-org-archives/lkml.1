Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbYGYJke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbYGYJke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 05:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbYGYJk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 05:40:26 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:58808 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbYGYJkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:40:25 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: linux-kernel@vger.kernel.org
Subject: question on error return if poll is interrupted
Date: Fri, 25 Jul 2008 11:41:14 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807251141.14638.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is this code from the gspca driver correct:

	if (mutex_lock_interruptible(&gspca_dev->queue_lock) != 0)
		return POLLERR;

Shouldn't poll() return -EINTR ?

	Regards
		Oliver
