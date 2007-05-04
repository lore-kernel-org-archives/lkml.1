Return-Path: <linux-kernel-owner+w=401wt.eu-S1161338AbXEDVRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161338AbXEDVRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 17:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161361AbXEDVRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 17:17:45 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:43952 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161338AbXEDVRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 17:17:44 -0400
Date: Fri, 4 May 2007 23:16:55 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Oliver Neukum <oliver@neukum.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch]clarification of coding style regarding conditional
 statements with two branches
In-Reply-To: <463B47AF.4010503@gmail.com>
Message-ID: <Pine.LNX.4.61.0705042315030.18504@yvahk01.tjqt.qr>
References: <200705040926.55257.oliver@neukum.org> <463B47AF.4010503@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 4 2007 16:48, Jiri Slaby wrote:
>>  
>> +Do not unnecessarily use braces where a single statement will do.
>> +
>> +if (condition)
>> +	action();
>> +
>> +This does not apply if one branch of a conditional statement is a single
>> +statement. Use braces in both branches.
>
>Why, what's wrong with
>if (condition) {
>	do_this();
>	do_that();
>} else
>	otherwise();
>
>? It's more readable/nicer in my eyes.

I'll just point to an opinion:
http://lkml.org/lkml/2006/9/5/36 , lower half. ("Secondly, whenever...")


Jan
-- 
