Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbZLBRU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbZLBRU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755236AbZLBRUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:20:25 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:54727 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbZLBRUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:20:24 -0500
Message-ID: <4B16A1B1.9010101@s5r6.in-berlin.de>
Date: Wed, 02 Dec 2009 18:19:45 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Mai Daftedar <mai.daftedar@gmail.com>
CC: linux-kernel@vger.kernel.org, clemens@ladisch.de
Subject: Re: Inter Thread Coomunication
References: <2cd4ff050912020417r27b52a89v4e676c7d4ab74ad4@mail.gmail.com>
In-Reply-To: <2cd4ff050912020417r27b52a89v4e676c7d4ab74ad4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mai Daftedar wrote:
> After some googling I learnt that using queues and pipes are expensive
> (effieciency wise) and that I should just pass in the parameters and
> use mutex to protect shared data...
> Can anyone add on to this tradeoff information

The entire point of threads (in contrast to processes) is to share an
address space for convenience or/and performance.  If a shared address
space is not really required, separate processes could be used instead
with the huge advantage of memory protection.
-- 
Stefan Richter
-=====-==--= ==-- ---=-
http://arcgraph.de/sr/
