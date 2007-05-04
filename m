Return-Path: <linux-kernel-owner+w=401wt.eu-S1031311AbXEDQQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031311AbXEDQQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031320AbXEDQQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:16:49 -0400
Received: from khc.piap.pl ([195.187.100.11]:58597 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031311AbXEDQQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:16:48 -0400
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch]clarification of coding style regarding conditional statements with two branches
References: <200705040926.55257.oliver@neukum.org>
	<463B47AF.4010503@gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 04 May 2007 18:16:46 +0200
In-Reply-To: <463B47AF.4010503@gmail.com> (Jiri Slaby's message of "Fri, 04 May 2007 16:48:15 +0200")
Message-ID: <m3hcqsbm35.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> writes:

> Why, what's wrong with
> if (condition) {
> 	do_this();
> 	do_that();
> } else
> 	otherwise();
>
> ? It's more readable/nicer in my eyes than

I think so. And it means less lines #.

>> +if (condition) {
>> +	do_this();
>> +	do_that();
>> +} else {
>> +	otherwise();
>> +}

Exception:

if (x) {
	if (y)
		foo1();
	else
		foo2();
} else
	bar();

The braces after if(x) are needed so nobody thinks it's:

if (x)
	if (y)
		foo1();
else
	foo2();
else
	bar();

-- 
Krzysztof Halasa
