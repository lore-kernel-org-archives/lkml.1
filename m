Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbZIQM2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbZIQM2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 08:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbZIQM2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 08:28:24 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:18819 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbZIQM2X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 08:28:23 -0400
From: sebastien cabaniols <sebastien.cabaniols@hp.com>
Organization: HP
To: linux-kernel@vger.kernel.org
Subject: performance counter for linux question.
Date: Thu, 17 Sep 2009 14:28:23 +0200
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200909171428.23610.sebastien.cabaniols@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

I am interested by monitoring instructions versus cycles with a Nehalem box 
using 2.6.31 with PCL.

Is there a way with perf report to display both counters ?

I used

perf record -e cycles -e instructions -a  for the recording session.

perf report -n seems to be doing what I need but for only one counter.

Is this a limitation of perf report ? 
Is this an architectural limitation of PCL ?
Is there more documentation than what is in the perf directory in the 2.6.31 
tarball ?


-- 
Sébastien Cabaniols
SCI Presales EMEA HP
current timezone = UTC+2 (localtime is approx. 14:20)
