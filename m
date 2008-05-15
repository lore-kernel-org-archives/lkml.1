Return-Path: <linux-kernel-owner+w=401wt.eu-S1764207AbYEOVhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764207AbYEOVhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 17:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbYEOVhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 17:37:04 -0400
Received: from main.gmane.org ([80.91.229.2]:43604 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122AbYEOVhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 17:37:03 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Weird Xorg radeon mirroring with linux-next-20080515 [paritial
 bisect]
Date: Thu, 15 May 2008 21:36:51 +0000 (UTC)
Message-ID: <g0iadj$dip$1@ger.gmane.org>
References: <g0hflu$b4q$1@ger.gmane.org> <482C744C.3050308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: Pan/0.129 (Benson & Hedges Moscow Gold)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 13:35:08 -0400, Chris Snook wrote:

> Sitsofe Wheeler wrote:
>> Hi,
>> 
>> When using the radeon xorg driver with linux-next-20080515 there is a
>> strange mirroring/stretching effect in the bottom eighth of the screen.
>> The problem seems to have started sometime between linux-next-20080513
>> and linux-next-20080515.
>> 
>> (Do you always have to have done bisection before reporting
>> regressions?)
>> 
>> 
> NO!

Ah, now you tell me : ) It sounded like bisection was what you did if you 
weren't a regular dev and you wanted your bug to get attention. I've 
spent a while trying to bisect this but didn't get all the way. My tests 
make me believe it lies somewhere between commits 
f5fbb15f66bd0a6017e4ca513217e823395502b7 and 
6a305693b777ecd710107387a9753117a54bcbf9 ...

The problem doesn't manifest directly after Xorg is started after boot - 
it seems to happen a few seconds later while services are still being 
started. Switching to a VT and back can make the problem go away.

-- 
Sitsofe | http://sucs.org/~sits/

