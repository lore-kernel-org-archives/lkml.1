Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbYJONWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbYJONWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 09:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbYJONWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 09:22:00 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:52381 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbYJONV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 09:21:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18677.61041.265144.217180@stoffel.org>
Date: Wed, 15 Oct 2008 09:21:53 -0400
From: "John Stoffel" <john@stoffel.org>
To: "Kaz Kylheku" <kkylheku@gmail.com>
Cc: "Chris Friesen" <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
Subject: Re: GPL question: using large contiguous memory in proprietary driver.
In-Reply-To: <3f43f78b0810141623s4282f9eof87014d2dee17810@mail.gmail.com>
References: <3f43f78b0810141456r159d71e7h9763e50e7dbc0c51@mail.gmail.com>
	<48F5193B.1010601@nortel.com>
	<3f43f78b0810141623s4282f9eof87014d2dee17810@mail.gmail.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Kaz" == Kaz Kylheku <kkylheku@gmail.com> writes:

Kaz> On Tue, Oct 14, 2008 at 3:12 PM, Chris Friesen <cfriesen@nortel.com> wrote:
>> Kaz Kylheku wrote:
>> 
>>> I have the following question. Suppose that some proprietary driver
>>> (otherwise completely clean, based only on non-GPL symbols)
>> 
>> The fact that it's not using GPL symbols does not actually mean that the
>> driver is not a derivative work of the kernel (and thus subject to the GPL).

Kaz> But thanks to the gracious tolerance of the kernel development
Kaz> community, such drivers are permitted to exist. That is the question:
Kaz> setting aside GPL chapter and verse, could that tolerance extend
Kaz> to allow such a driver to get a piece of boot-time memory, and if so,
Kaz> what mechanism would be tolerated?

Why doesn't your hardware support Scatter Gather Lists instead?  Then
you could setup virtual contiguous memory regions to use, but the
underlying physical RAM could be fragmented and you wouldn't care.

Seems like the more sensible solution.  Also, more people would be
*happy* to help you in that case, as opposed to the "I need a large
block of contiguous RAM" request which pops up a couple of times a
year on this list and pretty much always gets shot down.

John
