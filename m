Return-Path: <linux-kernel-owner+w=401wt.eu-S1757109AbZAMQnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109AbZAMQnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 11:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZAMQnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 11:43:05 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:52083 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbZAMQnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 11:43:04 -0500
Date: Tue, 13 Jan 2009 17:43:01 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] patches for the async infrastructure
Message-ID: <20090113174301.41b3e3df@gondolin>
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

following are two patches for the async infrastructure:

1) Try to handle failures when starting threads. (Failure to create the
manager thread is rather pathological, though.)
2) Add some kerneldoc to the exported functions. (I'm not sure whether
the term 'running list' is descriptive enough, but I can't think of
anything better...)

Patches are against current -git.
