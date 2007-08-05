Return-Path: <linux-kernel-owner+w=401wt.eu-S1757071AbXHESWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071AbXHESWK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 14:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbXHESV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 14:21:57 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:62193 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbXHESV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 14:21:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=o/t/w3UnCZwMHX1ez5nnwmiC72dWYOXr1Agy9XY8Yoi56u9AIX4j+49sFlh2XltG+f4vLyaTqNQMmrK2CChxt75Q2QNnY9udOKoUx6QfvKnu+fYOWp34Cj+hlM6UULmUX/yYbzGOLQ4MifBiOWvjzKkR4xg8R0f3auJNCZGDVd4=
Message-ID: <3aadbf9e0708051121m3ce8e044g104f58c17466eb60@mail.gmail.com>
Date: Mon, 6 Aug 2007 02:21:55 +0800
From: "Othello Reversi" <othello.reversi@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: Calling add_disk() from a work_queue item
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi List,

    I would like to know why calling add_disk() from a kernel thread
which is running from a work_queue would cause the work item to block
with the "D" (disk wait) state at best under kernel 2.6.17 and cause a
hard-lockup on kernel 2.6.22.1?

    If I    recall correctly, work items running on the work_queue are
allowed to sleep, and add_disk() is known to sleep.  Did I miss out
some details such as a lock I have to acquire?

    Hope to hear a reply soon.

Regards,
Othello

PS: Would like to be CC'ed comments and replies.
