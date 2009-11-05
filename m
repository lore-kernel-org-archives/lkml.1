Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbZKEQhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbZKEQhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 11:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757220AbZKEQht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 11:37:49 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:37790 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444AbZKEQht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 11:37:49 -0500
Message-ID: <4AF2FF5A.6050205@gmail.com>
Date: Thu, 05 Nov 2009 17:37:46 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
       mk@cm4all.com
Subject: Re: [PATCH] pipe: don't block after data has been written
References: <20091105153147.27473.19570.stgit@woodpecker.roonstrasse.net> <4AF2FD04.4030306@gmail.com> <20091105163603.GA4089@squirrel.roonstrasse.net>
In-Reply-To: <20091105163603.GA4089@squirrel.roonstrasse.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 05 Nov 2009 17:37:47 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Kellermann a écrit :
> On 2009/11/05 17:27, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> Your patch breaks many programs, that dont use poll()/select()
>>
>> char result[1000000];
>> main()
>> {
>> 	computethings();
>> 	write(1, buffer, 1000000);
>> }
> 
> Your code does not check the return value of write().  This is a bug.
> 

Welcome to real world.

