Return-Path: <linux-kernel-owner+w=401wt.eu-S1161488AbXD3Lkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161488AbXD3Lkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161661AbXD3Lko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:40:44 -0400
Received: from sceptre.pobox.com ([207.106.133.20]:55818 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161488AbXD3LkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:40:17 -0400
Message-ID: <4635D59C.4050300@hp.com>
Date: Mon, 30 Apr 2007 07:40:12 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Reply-To: Alan.Brunelle@hp.com
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: CFQ IO scheduler patch series - AIM7 DBase results on a 16-way IA64
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The results from a single run of an AIM7 DBase load on a 16-way ia64 box 
(64GB RAM + 144 FC disks) showed a slight regression (~0.5%) by adding 
in this patch. (Graph can be found at   
http://free.linux.hp.com/~adb/cfq/cfq_dbase.png   ) It is only a single 
set of runs, on a single platform, but it is something to keep an eye on 
as the regression showed itself across the complete run.

Alan D. Brunelle

