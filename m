Return-Path: <linux-kernel-owner+w=401wt.eu-S1760125AbZASMps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125AbZASMps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 07:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759985AbZASMpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 07:45:31 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:53373 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759962AbZASMpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 07:45:30 -0500
Date: Mon, 19 Jan 2009 13:45:27 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] async fixes and documentation
Message-ID: <20090119134527.60ca1119@gondolin>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are the async patches I currently have on my disk.

[1/3] async: Fix running list handling.
[2/3] async: Handle kthread_run() return codes.
[3/3] async: Add some documentation.

Patch 2 now uses msleep() to recover instead of scheduling.

All apply to current git head.
