Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbYGRMAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbYGRMAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbYGRMAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:00:07 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33880 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbYGRMAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:00:06 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4880856A.5050107@s5r6.in-berlin.de>
Date: Fri, 18 Jul 2008 13:58:34 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080614 SeaMonkey/1.1.9
MIME-Version: 1.0
To: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       krh@redhat.com
Subject: Re: PATCH] firewire: add padding to some struct
References: <416379761.08031@ustc.edu.cn> <488080B1.8010207@s5r6.in-berlin.de>
In-Reply-To: <488080B1.8010207@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> I don't understand what the problem is.  As long as both kernel and
> library use "response.data" or "&response + offsetof(typeof(response),
> data)", they will write and read at the correct location.

PS, of course the math of the latter should look more like
	(char *)&response + offsetof(...)
-- 
Stefan Richter
-=====-==--- -=== =--=-
http://arcgraph.de/sr/
