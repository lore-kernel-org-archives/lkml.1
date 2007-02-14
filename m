Return-Path: <linux-kernel-owner+w=401wt.eu-S932340AbXBNP01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340AbXBNP01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 10:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932341AbXBNP01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 10:26:27 -0500
Received: from orangesrv.RZ.UniBw-Muenchen.de ([137.193.10.40]:60055 "EHLO
	OrangeSrv.rz.unibw-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932340AbXBNP01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 10:26:27 -0500
X-Greylist: delayed 7732 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Feb 2007 10:26:26 EST
X-Remarks: If SPAM is relayed via OrangeSrv.rz.unibw-muenchen.de to outside of unibw-muenchen.de, please report it to abuse@unibw-muenchen.de
Message-ID: <45D30BDF.5010608@unibw.de>
Date: Wed, 14 Feb 2007 14:17:19 +0100
From: Johann Schuster <johann.schuster@unibw.de>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Measuring cpu time using getrusage
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

currently i'm trying to measure the cpu times for
numerical algorithms written in C using two calls of
getrusage() and then calculating the time difference.

According to the man page of getrusage i looked at the
user time of my process. Surprisingly the measured user
times vary strongly depending on the system load of the
machine.
A heavy system load nearly doubles the measured time
for my routine.

Does anyone know a better way to measure the used
cpu cycles of a given process (or part of a program)
or can anyone give me a hint if i missed some important
fact.

Any help appreciated. Thank you in advance.


Johann Schuster
