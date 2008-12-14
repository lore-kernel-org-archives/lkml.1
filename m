Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbYLNA4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbYLNA4j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 19:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYLNA4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 19:56:32 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51351 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYLNA4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 19:56:31 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <494459B5.6050806@s5r6.in-berlin.de>
Date: Sun, 14 Dec 2008 01:56:21 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] ieee1394: mark bus_info_data was a __be32 array
References: <1229209354.11257.11.camel@brick>	 <4944557A.7060902@s5r6.in-berlin.de> <1229215991.11257.18.camel@brick>
In-Reply-To: <1229215991.11257.18.camel@brick>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> On Sun, 2008-12-14 at 01:38 +0100, Stefan Richter wrote:
>> I dropped two hunks from "mark bus_info_data..." due to another change
...
> Looks OK to me, I needed to change the definition of get_max_rom to take
> a be32 as it was only ever passed the bus_info_data, now that the other
> patch removes that function entirely, the two hunks you dropped are no
> longer needed.

Ah, I wanted to remove get_max_rom from the changelog as well but then
forgot it...
-- 
Stefan Richter
-=====-==--- ==-- -===-
http://arcgraph.de/sr/
