Return-Path: <linux-kernel-owner+w=401wt.eu-S1764460AbYJJU55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764460AbYJJU55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760098AbYJJU5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:57:44 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:46944 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760243AbYJJU5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:57:43 -0400
Message-ID: <48EFC1BE.5010300@fr.ibm.com>
Date: Fri, 10 Oct 2008 22:57:34 +0200
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Greg Kurz <gkurz@fr.ibm.com>, Oren Laadan <orenl@cs.columbia.edu>,
       Ingo Molnar <mingo@elte.hu>, containers@lists.linux-foundation.org,
       arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] Track in-kernel when we expect	checkpoint/restart
 to work
References: <20081009190405.13A253CB@kernel> <1223626834.8787.8.camel@localhost.localdomain> <48EF144D.1050906@fr.ibm.com> <20081010145934.GF11695@elte.hu> <48EF7211.2000303@cs.columbia.edu> <1223656489.10017.33.camel@localhost.localdomain> <1223656603.11830.50.camel@nimitz>
In-Reply-To: <1223656603.11830.50.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Fri, 2008-10-10 at 18:34 +0200, Greg Kurz wrote:
>> This flag is weak... testing it gives absolutly no hint whether the
>> checkpoint may succeed or not. As it is designed now, a user can only be
>> aware that checkpoint is *forever* denied. I agree that it's only useful
>> as a "flexible CR todo list".
> 
> Cool, so everyone agrees the patch is useful!

Yes, definitively. It is a good idea.
