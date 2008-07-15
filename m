Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbYGOWs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbYGOWs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbYGOWsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:48:16 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:48845 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbYGOWsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:48:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=C8DfAPAIDO9rV+EJNJ1QvfmeWR+2Fb0MJ1qFhuT2Q9+Yaz2uqs5Bn0ftwN5D8qEp3Y
         pHxzGevk6DDjXsVSXiu0kLAdZBu2/xAJ0X26zUeRIJa/wYnxTKATGtZ72OSKIEBgkBkY
         sb8ZKv02d0BMgsW57TzTOK9lzZQ6ZajAxnAks=
Message-ID: <3aa654a40807151548t485ea8e6k1d7e261277c1c5aa@mail.gmail.com>
Date: Tue, 15 Jul 2008 15:48:13 -0700
From: "Avuton Olrich" <avuton@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: s2disk: system powers up again after power off
Cc: "Martin Michlmayr" <tbm@cyrius.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200807152224.19559.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080715124733.GA4111@deprecation.cyrius.com>
	 <3aa654a40807150605r6d6206delcd903aac58f6291d@mail.gmail.com>
	 <200807152224.19559.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 1:24 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, 15 of July 2008, Avuton Olrich wrote:
>> On Tue, Jul 15, 2008 at 5:47 AM, Martin Michlmayr <tbm@cyrius.com> wrote:
>> > When I use s2disk to suspend my HP 2510p notebook, it writes
>> > everything to disk, and powers off... but after 2-3 seconds it often
>> > powers on again.  This doesn't happen all the time but quite
>> > frequently (definitely in the majority of cases).
>> >
>> > I believe I've never seen this when I use "halt" to power off the
>> > machine (but I don't use halt very often).
>> >
>> > Any idea?
>>
>> Ugh, this happens here too, this started occuring before 2.6.25 but
>> every time I try to bisect it takes hours and I end up screwing up
>> somewhere along the way, so I haven't had time to bisect this
>> correctly.
>
> Please try to put "shutdown method = shutdown" into the s2disk's configuration
> file and see what happens in that case.

Anything a little less fancy? I use pm-hibernate, or gnome's Power
Manager to hibernate; I don't even have s2disk installed, sorry I
should have mentioned that.
-- 
avuton
--
 "I've got a fever. And the only prescription is more cowbell." --
Christopher Walken
