Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbYIBWVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbYIBWVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 18:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbYIBWVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 18:21:13 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4065 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbYIBWVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 18:21:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: CodingStyle question: multiple statements on a single line
Date: Wed, 3 Sep 2008 00:20:59 +0200
User-Agent: KMail/1.9.9
Cc: "v4l-dvb maintainer list" <v4l-dvb-maintainer@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809030021.00122.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On the v4l-dvb list there has been confusion on how to interpret the 
following in the CodingStyle document:

"Don't put multiple statements on a single line unless you have 
something to hide:

        if (condition) do_this;
          do_something_everytime;

Don't put multiple assignments on a single line either.  Kernel coding 
style is super simple.  Avoid tricky expressions."

Does this mean:

1) Yes, after an 'if' you can put a single statement like this:

	if (a) b;

2) No, never use the 'if (a) b;' construction. Put 'b;' on the next line 
instead.

It's the 'have something to hide' part that confuses people: is this 
literal or is this sarcastic? This should be reworded to whatever is 
really meant.

And in general, why is this:

if (a) {
	b;
}

not accepted by the CodingStyle? (At least as I understand it)

Many people find this more readable and certainly safer. Certainly in 
cases like this:

for (...)
	for (...)
		statement;

I would really prefer to have curly brackets as that is much clearer. I 
would suggest that having curly brackets around a single statement is 
made optional. Especially in view of the sentence 'Avoid tricky 
expressions' I would say that this:

if (a)
	b;

is definitely trickier than:

if (a) {
	b;
}

All it takes is a single indentation error to get into trouble here.

Regards,

	Hans
